/*
 * Study Design Service for the GLIMMPSE Software System.  
 * This service stores study design definitions for users of the GLIMMSE interface.
 * Service contain all information related to a power or sample size calculation.  
 * The Study Design Service simplifies communication between different screens in the user interface.
 * 
 * Copyright (C) 2010 Regents of the University of Colorado.  
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
package edu.ucdenver.bios.studydesignsvc.resource;

import java.util.regex.Pattern;

import org.restlet.data.Status;
import org.restlet.resource.Delete;
import org.restlet.resource.Get;
import org.restlet.resource.Post;
import org.restlet.resource.Put;
import org.restlet.resource.ResourceException;
import org.restlet.resource.ServerResource;

import edu.ucdenver.bios.studydesignsvc.application.StudyDesignLogger;
import edu.ucdenver.bios.studydesignsvc.manager.PowerCurveManager;
import edu.ucdenver.bios.webservice.common.domain.PowerCurveDescription;
import edu.ucdenver.bios.webservice.common.domain.UuidPowerCurveDescription;
import edu.ucdenver.bios.webservice.common.hibernate.BaseManagerException;
import edu.ucdenver.bios.webservice.common.uuid.UUIDUtils;

// TODO: Auto-generated Javadoc
/**
 * Concrete class which implements methods of Power Curve Resource interface.
 * See the StudyDesignApplication class for URI mappings
 * 
 * @author Uttara Sakhadeo
 */
public class PowerCurveServerResource extends ServerResource implements
        PowerCurveResource {
    
    /**
     * Creates the UuidPowerCurveDescription.
     * 
     * @param uuidPowerCurve
     *            the uuid power curve
     * @return the uuid power curve description
     */
    @Post("application/json")
    public final UuidPowerCurveDescription create(
            UuidPowerCurveDescription uuidPowerCurve) {
        PowerCurveManager powerCurveManager = null;
        byte[] uuid = uuidPowerCurve.getUuid();
        /*
         * Check : empty uuid.
         */
        if (uuid == null) {
            throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST,
                    "no study design UUID specified");
        }
        /*
         * Check : empty PowerCurveDescription.
         */
        PowerCurveDescription newPowerCurve = uuidPowerCurve
                .getPowerCurveDescription();
        if (newPowerCurve == null) {
            throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST,
                    "no Confidence Interval Description specified");
        }
        /*
         * Validate Uuid.
         */
        boolean uuidFlag = false;
        try {
            uuidFlag = Pattern.matches("[0-9a-fA-F]{32}",
                    UUIDUtils.bytesToHex(uuid));
        } catch (Exception e) {
            throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST,
                    "invalid UUID specified");
        }
        if (!uuidFlag) {
            throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST,
                    "invalid UUID specified");
        }
        
        try {
            /*
             * Save PowerCurveDescription.
             */
            powerCurveManager = new PowerCurveManager();
            powerCurveManager.beginTransaction();
            uuidPowerCurve = powerCurveManager.saveOrUpdate(uuidPowerCurve,
                    true);
            powerCurveManager.commit();

        } catch (BaseManagerException bme) {
            System.out.println(bme.getMessage());
            StudyDesignLogger.getInstance().error(bme.getMessage());
            if (powerCurveManager != null) {
                try {
                    powerCurveManager.rollback();
                } catch (BaseManagerException re) {
                    uuidPowerCurve = null;
                }
            }
            uuidPowerCurve = null;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            StudyDesignLogger.getInstance().error(e.getMessage());
            if (powerCurveManager != null) {
                try {
                    powerCurveManager.rollback();
                } catch (BaseManagerException re) {
                    uuidPowerCurve = null;
                }
            }
            uuidPowerCurve = null;
        }
        return uuidPowerCurve;
    }

    /**
     * Update UuidPowerCurveDescription.
     * 
     * @param uuidPowerCurve
     *            the uuid power curve
     * @return the uuid power curve description
     */
    @Put("application/json")
    public final UuidPowerCurveDescription update(
            final UuidPowerCurveDescription uuidPowerCurve) {
        return create(uuidPowerCurve);
    }

    /**
     * Removes the UuidPowerCurveDescription.
     * 
     * @param uuid
     *            the uuid
     * @return the uuid power curve description
     */
    @Delete("application/json")
    public final UuidPowerCurveDescription remove(final byte[] uuid) {
        PowerCurveManager powerCurveManager = null;
        UuidPowerCurveDescription uuidPowerCurve = null;
        /*
         * Check : empty uuid.
         */
        if (uuid == null) {
            throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST,
                    "no study design UUID specified");
        }
        /*
         * Validate Uuid.
         */
        boolean uuidFlag = false;
        try {
            uuidFlag = Pattern.matches("[0-9a-fA-F]{32}",
                    UUIDUtils.bytesToHex(uuid));
        } catch (Exception e) {
            throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST,
                    "invalid UUID specified");
        }
        if (!uuidFlag) {
            throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST,
                    "invalid UUID specified");
        }
        
        try {
            /*
             * Delete PowerCurveDescription.
             */
            powerCurveManager = new PowerCurveManager();
            powerCurveManager.beginTransaction();
            uuidPowerCurve = powerCurveManager.delete(uuid);
            powerCurveManager.commit();

        } catch (BaseManagerException bme) {
            System.out.println(bme.getMessage());
            StudyDesignLogger.getInstance().error(bme.getMessage());
            if (powerCurveManager != null) {
                try {
                    powerCurveManager.rollback();
                } catch (BaseManagerException re) {
                    uuidPowerCurve = null;
                }
            }
            uuidPowerCurve = null;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            StudyDesignLogger.getInstance().error(e.getMessage());
            if (powerCurveManager != null) {
                try {
                    powerCurveManager.rollback();
                } catch (BaseManagerException re) {
                    uuidPowerCurve = null;
                }
            }
            uuidPowerCurve = null;
        }
        return uuidPowerCurve;
    }

}
