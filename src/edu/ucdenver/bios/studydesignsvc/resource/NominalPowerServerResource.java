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

import java.util.List;

import org.restlet.data.Status;
import org.restlet.resource.Delete;
import org.restlet.resource.Get;
import org.restlet.resource.Post;
import org.restlet.resource.Put;
import org.restlet.resource.ResourceException;
import org.restlet.resource.ServerResource;

import edu.ucdenver.bios.studydesignsvc.application.StudyDesignLogger;
import edu.ucdenver.bios.studydesignsvc.exceptions.StudyDesignException;
import edu.ucdenver.bios.studydesignsvc.manager.NominalPowerManager;
import edu.ucdenver.bios.studydesignsvc.manager.StudyDesignManager;
import edu.ucdenver.bios.webservice.common.domain.NominalPower;
import edu.ucdenver.bios.webservice.common.domain.StudyDesign;
import edu.ucdenver.bios.webservice.common.hibernate.BaseManagerException;

/**
 * Server Resource class for handling requests for the Nominal Power object. 
 * See the StudyDesignApplication class for URI mappings
 * 
 * @author Uttara Sakhadeo
 */
public class NominalPowerServerResource  extends ServerResource
implements NominalPowerResource 
{
	NominalPowerManager nominalPowerManager = null; 
	StudyDesignManager studyDesignManager = null;
	boolean uuidFlag;

	/**
     * Retrieve a NominalPower object for specified UUID.
     * 
     * @param byte[]
     * @return List<NominalPower>
     */
	@Get("json")
	public List<NominalPower> retrieve(byte[] uuid) 
	{
		List<NominalPower> nominalPowerList = null;
		if(uuid==null)
			throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST, 
					"no study design UUID specified");		
		try
		{
			/* ----------------------------------------------------
			 * Check for existence of a UUID in Study Design object 
			 * ----------------------------------------------------*/
			studyDesignManager = new StudyDesignManager();			
			studyDesignManager.beginTransaction();								
				uuidFlag = studyDesignManager.hasUUID(uuid);
				if(uuidFlag)
            	{		
					StudyDesign studyDesign = studyDesignManager.get(uuid);
					if(studyDesign!=null)
						nominalPowerList = studyDesign.getNominalPowerList();					
            	}				
			studyDesignManager.commit();					
		}
		catch (BaseManagerException bme)
		{
			System.out.println(bme.getMessage());
			StudyDesignLogger.getInstance().error(bme.getMessage());
			if(nominalPowerManager!=null)
			{
				try
				{nominalPowerManager.rollback();}				
				catch(BaseManagerException re)
				{nominalPowerList = null;}				
			}
			nominalPowerList = null;
		}	
		catch(StudyDesignException sde)
		{
			System.out.println(sde.getMessage());
			StudyDesignLogger.getInstance().error(sde.getMessage());
			if(studyDesignManager!=null)
			{
				try {studyDesignManager.rollback();}
				catch(BaseManagerException re) {nominalPowerList = null;}					
			}
			nominalPowerList = null;
		}								
		return nominalPowerList;
	}

	/**
     * Create a NominalPower object for specified UUID.
     * 
     * @param byte[]
     * @param List<NominalPower>
     * @return List<NominalPower>
     */
	@Post("json")
	public List<NominalPower> create(byte[] uuid,List<NominalPower> nominalPowerList) 
	{		
		StudyDesign studyDesign =null;
		if(uuid==null)
			throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST, 
					"no study design UUID specified");		
		try
		{
			/* ----------------------------------------------------
			 * Check for existence of a UUID in Study Design object 
			 * ----------------------------------------------------*/
			studyDesignManager = new StudyDesignManager();
			studyDesignManager.beginTransaction();				
				uuidFlag = studyDesignManager.hasUUID(uuid);				
				if(uuidFlag)
            	{
					studyDesign = studyDesignManager.get(uuid);					
				}																									            				
				else
				{throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST, 
						"no study design UUID specified");}
			studyDesignManager.commit();
			/* ----------------------------------------------------
			 * Remove existing Nominal Power for this object 
			 * ----------------------------------------------------*/			
			if(nominalPowerList!=null)
				removeFrom(studyDesign);	
			/* ----------------------------------------------------
			 * Save new Nominal Power List object 
			 * ----------------------------------------------------*/
			if(uuidFlag)
			{
				studyDesign.setNominalPowerList(nominalPowerList);
				studyDesignManager = new StudyDesignManager();
				studyDesignManager.beginTransaction();
					studyDesignManager.saveOrUpdate(studyDesign, false);
				studyDesignManager.commit();
			}
		}
		catch (BaseManagerException bme)
		{
			System.out.println(bme.getMessage());
			StudyDesignLogger.getInstance().error(bme.getMessage());
			if(nominalPowerManager!=null)
			{
				try
				{nominalPowerManager.rollback();}				
				catch(BaseManagerException re)
				{nominalPowerList = null;}				
			}
			nominalPowerList = null;
		}	
		catch(StudyDesignException sde)
		{
			System.out.println(sde.getMessage());
			StudyDesignLogger.getInstance().error(sde.getMessage());
			if(studyDesignManager!=null)
			{
				try {studyDesignManager.rollback();}
				catch(BaseManagerException re) {nominalPowerList = null;}					
			}
			nominalPowerList = null;
		}								
		return nominalPowerList;
	}

	/**
     * Update a NominalPower object for specified UUID.
     * 
     * @param byte[]
     * @param List<NominalPower>
     * @return List<NominalPower>
     */
	@Put("json")
	public List<NominalPower> update(byte[] uuid,List<NominalPower> nominalPowerList) 
	{
		return create(uuid,nominalPowerList);
	}

	/**
     * Delete a NominalPower object for specified UUID.
     * 
     * @param byte[]
     * @return List<NominalPower>
     */
	@Delete("json")
	public List<NominalPower> remove(byte[] uuid) 
	{
		List<NominalPower> nominalPowerList = null;
		StudyDesign studyDesign = null;
		if(uuid==null)
			throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST, 
					"no study design UUID specified");		
		try
		{
			/* ----------------------------------------------------
			 * Check for existence of a UUID in Study Design object 
			 * ----------------------------------------------------*/
			studyDesignManager = new StudyDesignManager();			
			studyDesignManager.beginTransaction();								
				uuidFlag = studyDesignManager.hasUUID(uuid);
				if(uuidFlag)
            	{		
					studyDesign = studyDesignManager.get(uuid);
					if(studyDesign!=null)
						nominalPowerList = studyDesign.getNominalPowerList();
					if(nominalPowerList.isEmpty())
						throw new ResourceException(Status.CLIENT_ERROR_BAD_REQUEST, 
								"no TypeIError is specified");					
            	}				
			studyDesignManager.commit();
			/* ----------------------------------------------------
			 * Remove existing Type I Error objects for this object 
			 * ----------------------------------------------------*/
			if(studyDesign.getNominalPowerList()!=null)
			{
				nominalPowerManager = new NominalPowerManager();
				nominalPowerManager.beginTransaction();
					nominalPowerList = nominalPowerManager.delete(uuid,nominalPowerList);
				nominalPowerManager.commit();
			}
		}
		catch (BaseManagerException bme)
		{
			System.out.println(bme.getMessage());
			StudyDesignLogger.getInstance().error(bme.getMessage());
			if(nominalPowerManager!=null)
			{
				try
				{nominalPowerManager.rollback();}				
				catch(BaseManagerException re)
				{nominalPowerList = null;}				
			}
			nominalPowerList = null;
		}	
		catch(StudyDesignException sde)
		{
			System.out.println(sde.getMessage());
			StudyDesignLogger.getInstance().error(sde.getMessage());
			if(studyDesignManager!=null)
			{
				try {studyDesignManager.rollback();}
				catch(BaseManagerException re) {nominalPowerList = null;}					
			}
			nominalPowerList = null;
		}		
		return nominalPowerList;
	}

	/**
     * Delete a NominalPower object for specified Study Design.
     * 
     * @param StudyDesign
     * @return List<NominalPower>
     */
	@Override
	@Delete("json")
	public List<NominalPower> removeFrom(StudyDesign studyDesign) 
	{
		List<NominalPower> nominalPowerList = null;	
        try
        {                    			
        	nominalPowerManager = new NominalPowerManager();
        	nominalPowerManager.beginTransaction();
        		nominalPowerList=nominalPowerManager.delete(studyDesign.getUuid(),studyDesign.getNominalPowerList());
        	nominalPowerManager.commit();        	       
        }
        catch (BaseManagerException bme)
        {
        	System.out.println(bme.getMessage());
            StudyDesignLogger.getInstance().error("Failed to load Study Design information: " + bme.getMessage());
            if (studyDesignManager != null) try { studyDesignManager.rollback(); } catch (BaseManagerException e) {}
            if (nominalPowerManager != null) try { nominalPowerManager.rollback(); } catch (BaseManagerException e) {}
            nominalPowerList = null;           
        }
       return nominalPowerList;
	}

}