/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.content.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import org.dspace.authorize.AuthorizeException;
import org.dspace.content.MetadataField;
import org.dspace.content.MetadataFieldName;
import org.dspace.content.MetadataSchema;
import org.dspace.content.NonUniqueMetadataException;
import org.dspace.core.Context;

/**
 * Service interface class for the MetadataField object.
 * The implementation of this class is responsible for all business logic calls for the MetadataField object and is
 * autowired by spring
 *
 * @author kevinvandevelde at atmire.com
 */
public interface MetadataFieldService {

    /**
     * Creates a new metadata field.
     *
     * @param context        DSpace context object
     * @param metadataSchema schema
     * @param scopeNote      scope note
     * @param element        element
     * @param qualifier      qualifier
     * @return new MetadataField
     * @throws AuthorizeException         if authorization error
     * @throws SQLException               if database error
     * @throws NonUniqueMetadataException if an existing field with an identical element and qualifier is already
     *                                    present
     */
    public MetadataField create(Context context, MetadataSchema metadataSchema, String element, String qualifier,
                                String scopeNote)
        throws AuthorizeException, SQLException, NonUniqueMetadataException;

    /**
     * Find the field corresponding to the given numeric ID.  The ID is
     * a database key internal to DSpace.
     *
     * @param context context, in case we need to read it in from DB
     * @param id      the metadata field ID
     * @return the metadata field object
     * @throws SQLException if database error
     */
    public MetadataField find(Context context, int id) throws SQLException;

    /**
     * Retrieves the metadata field from the database.
     *
     * @param context        dspace context
     * @param metadataSchema schema
     * @param element        element name
     * @param qualifier      qualifier (may be ANY or null)
     * @return recalled metadata field
     * @throws SQLException if database error
     */
    public MetadataField findByElement(Context context, MetadataSchema metadataSchema, String element, String qualifier)
        throws SQLException;

    public MetadataField findByElement(Context context, String metadataSchemaName, String element, String qualifier)
        throws SQLException;

    /**
     * Separates an mdString in schema, element and qualifier parts, separated by a given separator
     *      And returns it's matching metadataField if found
     * @param context       dspace context
     * @param mdString      String being separated to find corresponding mdField (ex dc.contributor)
     * @param separator     Separator being used to separate the mdString
     * @return  Corresponding MetadataField if found
     */
    public MetadataField findByString(Context context, String mdString, char separator) throws SQLException;

    public List<MetadataField> findFieldsByElementNameUnqualified(Context context, String metadataSchema,
                                                                  String element)
        throws SQLException;

    /**
     * Retrieve all metadata field types from the registry
     *
     * @param context dspace context
     * @return an array of all the Dublin Core types
     * @throws SQLException if database error
     */
    public List<MetadataField> findAll(Context context) throws SQLException;

    /**
     * Return all metadata fields that are found in a given schema.
     *
     * @param context        dspace context
     * @param metadataSchema the metadata schema for which we want all our metadata fields
     * @return array of metadata fields
     * @throws SQLException if database error
     */
    public List<MetadataField> findAllInSchema(Context context, MetadataSchema metadataSchema)
        throws SQLException;


    /**
     * Update the metadata field in the database.
     *
     * @param context       dspace context
     * @param metadataField metadata field
     * @throws SQLException               if database error
     * @throws AuthorizeException         if authorization error
     * @throws NonUniqueMetadataException if an existing field with an identical element and qualifier is already
     *                                    present
     * @throws IOException                if IO error
     */
    public void update(Context context, MetadataField metadataField)
        throws SQLException, AuthorizeException, NonUniqueMetadataException, IOException;

    /**
     * Delete the metadata field.
     *
     * @param context       dspace context
     * @param metadataField metadata field
     * @throws SQLException       if database error
     * @throws AuthorizeException if authorization error
     */
    public void delete(Context context, MetadataField metadataField) throws SQLException, AuthorizeException;

    /**
     * Find all the metadata field names by the given schema and element.
     *
     * @param  context      dspace context
     * @param  schema       the metadata schema
     * @param  element      the element of the metadata field
     * @return              the metadata field names
     * @throws SQLException if database error
     */
    List<MetadataFieldName> findMetadataFieldNamesBySchemaAndElement(Context context, String schema, String element)
        throws SQLException;
}
