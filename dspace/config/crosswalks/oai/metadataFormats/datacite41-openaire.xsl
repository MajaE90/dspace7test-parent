<?xml version="1.0" encoding="UTF-8" ?>
<!-- 


    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/
    Developed by DSpace @ Lyncode <dspace@lyncode.com>
    
    > http://www.openarchives.org/OAI/2.0/oai_dc.xsd

 -->
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://www.lyncode.com/xoai"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    version="1.0">
    <xsl:output omit-xml-declaration="yes" method="xml" indent="yes" />
    
    <xsl:template match="/">
        <oai_datacite xsi:schemaLocation="http://schema.datacite.org/oai/oai-1.1/ http://schema.datacite.org/oai/oai-1.1/oai.xsd" >
            <schemaVersion>4.1</schemaVersion>
            <!-- <datacentreSymbol>XXXX</datacentreSymbol>  -->
            <payload>
                <resource xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4.1/metadata.xsd" >
                    
                    
                    <!-- placeholder variable contains the value of the placeholder -->
                    <xsl:variable name="placeholder">#PLACEHOLDER_PARENT_METADATA_VALUE#</xsl:variable>
                    
                    
                    <!-- select only one identifier -->
                    <xsl:variable name="doi" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='doi']/doc:element/doc:field[@name='value']"/>
                    <xsl:variable name="handle" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='uri']/doc:element/doc:field[@name='value']"/>
                    <xsl:variable name="url" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='url']/doc:element/doc:field[@name='value']"/>
                    <!-- <xsl:variable name="ark" select=""/> -->
                    <!-- <xsl:variable name="urn" select=""/> -->
                    <!-- <xsl:variable name="purl" select=""/> -->
                    
                    <xsl:choose>
                        <!-- DOI control identifier -->
                        <xsl:when test="$doi!=''">
                            <!-- create a substring of DOI element that contains only the DOI value. -->
                            <identifier identifierType="DOI">
                                <xsl:value-of select="concat('10.', substring-after($doi, '10.'))"/>
                            </identifier>
                        </xsl:when>
                        
                        <!-- Handle (under dc.identifier.uri metadata) control identifier -->
                        <xsl:when test="$handle!=''">
                            <identifier identifierType="Handle">
                                <xsl:value-of select="$handle"/>
                            </identifier>
                        </xsl:when>
                        
                        <!-- URL control identifier -->
                        <xsl:when test="$url!=''">
                            <identifier identifierType="URL">
                                <xsl:value-of select="$url"/>
                            </identifier>
                        </xsl:when>
                        
                        <!-- ARK control identifier -->
                        <!-- <xsl:when test="$ark!=''">
                            <identifier identifierType="ARK">
                                <xsl:value-of select="$ark"/>
                            </identifier>
                        </xsl:when> -->
                        
                        <!-- URN control identifier -->
                        <!-- <xsl:when test="$urn!=''">
                            <identifier identifierType="URN">
                                <xsl:value-of select="$urn"/>
                            </identifier>
                        </xsl:when> -->
                        
                        <!-- PURL control identifier -->
                        <!-- <xsl:when test="$purl!=''">
                            <identifier identifierType="PURL">
                                <xsl:value-of select="$purl"/>
                            </identifier>
                        </xsl:when> -->
                    </xsl:choose>
                    
                    
                    
                    <!-- select all names and relative affiliations -->
                    <xsl:variable name="author" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element/doc:field[@name='value']"/>
                    <xsl:variable name="department" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='department']/doc:element/doc:field[@name='value']"/>
                    <xsl:variable name="orcid" select="doc:metadata/doc:element[@name='cris']/doc:element[@name='virtual']/doc:element[@name='author-orcid']/doc:element/doc:field[@name='value']"/>
                    
                    <xsl:if test="$author!=''">
                        <creators>
                            <xsl:for-each select="$author">
                                <xsl:if test=".!=''">
                                    <creator>
                                        <xsl:variable name="counter" select="position()"/>
                                        <creatorName nameType="Personal">
                                            <xsl:value-of select="."/>
                                        </creatorName>
                                        <xsl:if test="contains(., ',')">        
                                            <givenName>
                                                <xsl:value-of select="substring-after(., ', ')"/>
                                            </givenName>
                                            <familyName>
                                                <xsl:value-of select="substring-before(., ',')"/>
                                            </familyName>
                                        </xsl:if>
                                        <xsl:if test="$orcid[$counter]!='' and $orcid[$counter]!=$placeholder">
                                            <nameIdentifier schemeURI="https://orcid.org/" nameIdentifierScheme="ORCID">
                                                <!-- <xsl:text>https://orcid.org/</xsl:text> -->
                                                <xsl:value-of select="$orcid[$counter]"/>
                                            </nameIdentifier>
                                        </xsl:if>
                                        <xsl:if test="$department[$counter]!=''">
                                            <affiliation>
                                                <xsl:value-of select="$department[$counter]"/>
                                            </affiliation>
                                        </xsl:if>
                                    </creator>
                                 </xsl:if>
                            </xsl:for-each>
                        </creators>
                     </xsl:if>
                    
                    
                    
                    <!-- select all titles -->
                    <xsl:variable name="title" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='title']//doc:field[@name='value']"/>
                    
                    <xsl:if test="$title!=''">
                        <titles>
                            <xsl:for-each select="$title">
                                <xsl:if test=".!=''">
                                    <xsl:choose>
                                        <xsl:when test="../../@name='alternative'">
                                            <xsl:choose>
                                                <xsl:when test="../@name!='none' and ../@name!='*' and ../@name!=''">
                                                    <title xml:lang="{../@name}" titleType="Alternative Title">
                                                        <xsl:value-of select="."/>
                                                    </title>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <title titleType="Alternative Title">
                                                        <xsl:value-of select="."/>
                                                    </title>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="../@name!='none' and ../@name!='*' and ../@name!=''">
                                                    <title xml:lang="{../@name}">
                                                        <xsl:value-of select="."/>
                                                    </title>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <title>
                                                        <xsl:value-of select="."/>
                                                    </title>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:for-each>
                        </titles>
                    </xsl:if>
                    
                    
                    
                    <!-- select the publisher -->
                    <xsl:variable name="publisher" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='publisher']/doc:element[@name='name']/doc:element/doc:field[@name='value']"/>
                    
                    <xsl:if test="$publisher!=''">
                        <publisher>
                            <xsl:value-of select="$publisher"/>
                        </publisher>
                    </xsl:if>
                    
                    
                    
                    <!-- select the publication year -->
                    <xsl:variable name="euTermURI" select="doc:metadata/doc:element[@name='others']/doc:element[@name='accesscondition']/doc:field[@name='euTermURI']"/>
                    <xsl:variable name="date_embargo" select="doc:metadata/doc:element[@name='others']/doc:element[@name='accesscondition']/doc:field[@name='embargoEndDate']"/>
                    <xsl:variable name="date_issued" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='issued']/doc:element/doc:field[@name='value']"/>
                    
                    <xsl:choose>
                        <xsl:when test="$date_embargo!=''">
                            <publicationYear>
                                <xsl:value-of select="substring($date_embargo, 1, 4)"/>
                            </publicationYear>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:if test="$date_issued!=''">
                                <publicationYear>
                                    <xsl:value-of select="substring($date_issued, 1, 4)"/>
                                </publicationYear>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <!-- select all subjects -->
                    <xsl:variable name="subject" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='subject']//doc:field[@name='value']"/>
                    
                    <xsl:if test="$subject!=''">
                        <subjects>
                            <xsl:for-each select="$subject">
                                <xsl:if test=".!=''">
                                    <xsl:choose>
                                        <xsl:when test="../@name!='none' and ../@name!='*' and ../@name!=''">
                                            <subject xml:lang="{../@name}"> <!-- subjectScheme="" --> <!-- schemeURI="" --> <!-- valueURI="" -->
                                                <xsl:value-of select="."/>
                                            </subject>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <subject> <!-- subjectScheme="" --> <!-- schemeURI="" --> <!-- valueURI="" -->
                                                <xsl:value-of select="."/>
                                            </subject>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:for-each>
                        </subjects>
                    </xsl:if>
                    
                    <!-- select all contributors -->
                    <xsl:variable name="contributor" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element"/>
                    <xsl:variable name="editordepartment" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='editordepartment']/doc:element/doc:field[@name='value']"/>
                    <xsl:variable name="advisordepartment" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='advisordepartment']/doc:element/doc:field[@name='value']"/>
                    
                    <!-- variable check_contributors is used to control if there are other contributors -->
                    <xsl:variable name="check_contributors">
                        <xsl:for-each select="$contributor">
                            <xsl:if test="@name!='authorall' and @name!='author' and @name!='department'">
                                <xsl:for-each select="./doc:element/doc:field[@name='value']">
                                    <xsl:if test=".!=''">
                                        <xsl:value-of select="."/>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    
                    <xsl:if test="$check_contributors!=''">
                        <contributors>
                            <xsl:for-each select="$contributor">
                                <xsl:choose>
                                    <xsl:when test="@name='editor'">
                                        <xsl:for-each select="./doc:element/doc:field[@name='value']">
                                            <xsl:if test=".!=''">
                                                <!-- I can use nameIdentifier with nameIdentifierScheme attribute -->
                                                <contributor contributorType="Editor">
                                                    <xsl:variable name="counter" select="position()"/>
                                                    <contributorName nameType="Personal">
                                                        <xsl:value-of select="."/>
                                                    </contributorName>
                                                    <xsl:if test="contains(., ',')">
                                                        <givenName>
                                                            <xsl:value-of select="substring-after(., ', ')"/>
                                                        </givenName>
                                                        <familyName>
                                                            <xsl:value-of select="substring-before(., ',')"/>
                                                        </familyName>
                                                    </xsl:if>
                                                    <xsl:if test="$editordepartment[$counter]!=''">
                                                        <affiliation>
                                                            <xsl:value-of select="$editordepartment[$counter]"/>
                                                        </affiliation>
                                                    </xsl:if>
                                                </contributor>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    
                                    <xsl:when test="@name='advisor'">
                                        <xsl:for-each select="./doc:element/doc:field[@name='value']">
                                            <xsl:if test=".!=''">
                                                <!-- I can use nameIdentifier with nameIdentifierScheme attribute -->
                                                <contributor contributorType="Supervisor">
                                                <xsl:variable name="counter" select="position()"/>
                                                    <contributorName nameType="Personal">
                                                        <xsl:value-of select="."/>
                                                    </contributorName>
                                                    <xsl:if test="contains(.,',')">     
                                                    <givenName>
                                                        <xsl:value-of select="substring-after(., ', ')"/>
                                                    </givenName>
                                                    <familyName>
                                                        <xsl:value-of select="substring-before(., ',')"/>
                                                    </familyName>
                                                    </xsl:if>
                                                    <xsl:if test="$advisordepartment[$counter]!=''">
                                                        <affiliation>
                                                            <xsl:value-of select="$advisordepartment[$counter]"/>
                                                        </affiliation>
                                                    </xsl:if>
                                                </contributor>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    
                                </xsl:choose>
                            </xsl:for-each>
                        </contributors>
                    </xsl:if>
                    
                    
                    
                    <!-- select the date -->
                    <xsl:choose>
                        <!-- $grantfulltext variable is declared before the tag <publicationYear> -->
                        <xsl:when test="$date_embargo!=''">
                            <dates>
                                <date dateType="Available">
                                    <xsl:value-of select="$date_embargo"/>
                                </date>
                                <date dateType="Accepted">
                                    <xsl:value-of select="$date_issued"/>
                                </date>
                            </dates>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:if test="$date_issued!=''">
                                <date dateType="Issued">
                                    <xsl:value-of select="$date_issued"/>
                                </date>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <!-- select the language -->
                    <xsl:variable name="language" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='language']//doc:field[@name='value']"/>
                    
                    <xsl:if test="$language!=''">
                        <language>
                            <xsl:value-of select="$language"/>
                        </language>
                    </xsl:if>
                    
                    
                    
                    <!-- select the resource type -->
                    <xsl:variable name="resourcetype" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='type']"/>
                    <xsl:variable name="resourcetype_values"> Audiovisual Collection DataPaper Dataset Event Image InteractiveResource Model PhysicalObject Service Software Sound Text Workflow Other </xsl:variable>
                    
                    <xsl:if test="$resourcetype/doc:element/doc:field[@name='value']!=''">
                        <xsl:choose>
                            <xsl:when test="contains($resourcetype_values, $resourcetype/doc:element/@name)">
                                <resourceType resourceTypeGeneral="{$resourcetype/doc:element/@name}">
                                    <xsl:value-of select="$resourcetype/doc:element/doc:field[@name='value']"/>
                                </resourceType>
                            </xsl:when>
                            
                            <xsl:when test="contains($resourcetype/doc:element/@name, 'Book') or contains($resourcetype/doc:element/@name, 'Article')">
                                <resourceType resourceTypeGeneral="Text">
                                    <xsl:value-of select="$resourcetype/doc:element/doc:field[@name='value']"/>
                                </resourceType>
                            </xsl:when>
                            
                            <xsl:when test="contains($resourcetype/doc:element/@name, 'Recording')">
                                <resourceType resourceTypeGeneral="Sound">
                                    <xsl:value-of select="$resourcetype/doc:element/doc:field[@name='value']"/>
                                </resourceType>
                             </xsl:when>
                             
                             <xsl:otherwise>
                                <resourceType resourceTypeGeneral="Other">
                                    <xsl:value-of select="$resourcetype/doc:element/doc:field[@name='value']"/>
                                </resourceType>
                             </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    
                    
                    
                    <!-- select all alternate identifiers -->
                    <xsl:choose>
                        <xsl:when test="$doi!=''">
                            <xsl:if test="$handle!='' or $url!=''">
                                <alternateIdentifiers>
                                    <!-- Handle control identifier -->
                                    <xsl:if test="$handle!=''">
                                        <alternateIdentifier alternateIdentifierType="Handle">
                                            <xsl:value-of select="$handle"/>
                                        </alternateIdentifier>
                                    </xsl:if>
                                    <!-- URL control identifier -->
                                    <xsl:if test="$url != ''">
                                        <alternateIdentifier alternateIdentifierType="URL">
                                            <xsl:value-of select="$url"/>
                                        </alternateIdentifier>
                                    </xsl:if>
                                    <!-- add ARK control identifier -->
                                    <!-- add URN control identifier -->
                                    <!-- add PURL control identifier -->
                                </alternateIdentifiers>
                            </xsl:if>
                        </xsl:when>
                        
                        <xsl:when test="$handle!=''">
                            <xsl:if test="$url!=''">
                                <alternateIdentifiers>
                                    <!-- URL control identifier -->
                                    <xsl:if test="$url!=''">
                                        <alternateIdentifier alternateIdentifierType="URL">
                                            <xsl:value-of select="$url"/>
                                        </alternateIdentifier>
                                    </xsl:if>
                                    <!-- add ARK control identifier -->
                                    <!-- add URN control identifier -->
                                    <!-- add PURL control identifier -->
                                </alternateIdentifiers>
                            </xsl:if>
                        </xsl:when>
                        
                        <!-- if use URL identifier, select ARK, URN and PURL as alternate identifiers -->
                            <!-- add ARK control identifier -->
                            <!-- add URN control identifier -->
                            <!-- add PURL control identifier -->
                        
                        <!-- if use ARK identifier, select URN and PURL as alternate identifiers -->
                            <!-- add URN control identifier -->
                            <!-- add PURL control identifier -->
                        
                        <!-- if use URN identifier, select PURL as alternate identifier -->
                            <!-- add PURL control identifier -->
                        
                        <!-- if use PURL identifier, select nothing because there aren't other identifiers -->
                    </xsl:choose>
                    
                    
                    
                    <!-- select all related identifiers -->
                    <xsl:variable name="ispartof" select="doc:metadata/doc:element[@name='crisitem']/doc:element[@name='journal']/doc:element[@name='journalissn']/doc:element/doc:field[@name='value']"/>
                    <xsl:variable name="isreferencedby" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='publication']/doc:element/doc:field[@name='authority']"/>
                    <xsl:variable name="references" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='dataset']/doc:element/doc:field[@name='authority']"/>
                    
                    <xsl:if test="($ispartof!='' and $ispartof!=$placeholder) or $isreferencedby!='' or $references!=''">
                        <relatedIdentifiers>
                            <!-- select IsPartOf type -->
                            <xsl:if test="$ispartof!='' and $ispartof!=$placeholder">
                                <relatedIdentifier relatedIdentifierType="ISSN" relationType="IsPartOf">
                                    <xsl:value-of select="$ispartof"/>
                                </relatedIdentifier>
                            </xsl:if>
                            
                            <!-- select IsReferencedBy type -->
                            <!-- if your repository doesn't use a real Handle fix the code below to refer to the URL -->
                            <xsl:if test="$isreferencedby!=''">
                                <xsl:for-each select="$isreferencedby">
                                    <relatedIdentifier relatedIdentifierType="Handle" relationType="IsReferencedBy">
                                        <xsl:text>https://hdl.handle.net/</xsl:text>
                                        <xsl:value-of select="."/>
                                    </relatedIdentifier>
                                </xsl:for-each>
                            </xsl:if>
                            
                            <!-- select References type -->
                            <!-- if your repository doesn't use a real Handle fix the code below to refer to the URL -->
                            <xsl:if test="$references!=''">
                                <relatedIdentifier relatedIdentifierType="Handle" relationType="References">
                                    <xsl:text>https://hdl.handle.net/</xsl:text>
                                    <xsl:value-of select="$references"/>
                                </relatedIdentifier>
                            </xsl:if>
                        </relatedIdentifiers>
                    </xsl:if>
                    
                    
                    
                    <!-- select all sizes and formats -->
                    <xsl:variable name="size" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='format']/doc:element[@name='extent']/doc:element/doc:field[@name='value']"/>
                    <xsl:variable name="format" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='format']/doc:element[@name='mimetype']/doc:element/doc:field[@name='value']"/>
                    
                    <!-- enable that to avoid size and format when multiple bitstreams are present -->
                    <!-- <xsl:variable name="check_sf">
                        <xsl:for-each select="doc:metadata/doc:element[@name='bundles']/doc:element[@name='bundle']">
                            <xsl:if test="./doc:field[@name='name']='ORIGINAL'">
                                <xsl:for-each select="./doc:element[@name='bitstreams']/doc:element[@name='bitstream']">
                                    <xsl:text>-</xsl:text>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable> -->
                    <xsl:variable name="check_sf"><xsl:text>-</xsl:text></xsl:variable>
                     
                    <xsl:if test="$check_sf='-'">
                        <!-- select all sizes -->
                        <sizes>
                            <xsl:for-each select="doc:metadata/doc:element[@name='bundles']/doc:element[@name='bundle']">
                                <xsl:if test="./doc:field[@name='name']='ORIGINAL'">
                                    <xsl:for-each select="./doc:element[@name='bitstreams']/doc:element[@name='bitstream']">
                                        <xsl:if test="./doc:element/doc:field[@name='size']!=''">
                                            <size>
                                                <xsl:value-of select="./doc:element/doc:field[@name='size']"/>
                                            </size>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:for-each>
                        </sizes>
                        <!-- select all formats -->
                        <formats>
                            <xsl:for-each select="doc:metadata/doc:element[@name='bundles']/doc:element[@name='bundle']">
                                <xsl:if test="./doc:field[@name='name']='ORIGINAL'">
                                <xsl:for-each select="./doc:element[@name='bitstreams']/doc:element[@name='bitstream']">
                                        <xsl:if test="./doc:element/doc:field[@name='format']!=''">
                                            <format>
                                                <xsl:value-of select="./doc:element/doc:field[@name='format']"/>
                                            </format>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:for-each>
                        </formats>
                    </xsl:if>
                    
                    
                    
                    <!-- select the version -->
                    <!-- versionnumber is typically not available --> 
                    <xsl:variable name="version" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='versionnumber']/doc:element/doc:field[@name='value']"/>
                    
                    <xsl:if test="$version!=''">
                        <version>
                            <xsl:value-of select="$version"/>
                        </version>
                    </xsl:if>
                    
                   <rightsList>
                        <rights rightsURI="{$euTermURI}" />
                   </rightsList>
                    
                    <!-- select the Abstract description -->
                    <xsl:variable name="abstract" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='abstract']//doc:field[@name='value']"/>
                    
                    <xsl:if test="$abstract!=''">
                        <descriptions>
                            <!-- select the Abstract description. -->
                            <xsl:choose>
                                <xsl:when test="$abstract/../@name!='none' and $abstract/../@name!='*' and $abstract/../@name!=''">
                                    <description xml:lang="{$abstract/../@name}" descriptionType="Abstract">
                                        <xsl:value-of select="$abstract"/>
                                    </description>
                                </xsl:when>
                                <xsl:otherwise>
                                    <description descriptionType="Abstract">
                                        <xsl:value-of select="$abstract"/>
                                    </description>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </descriptions>
                    </xsl:if>
                    
                    
                    
                    <!-- select all funding references -->
                    <xsl:variable name="funder" select="doc:metadata/doc:element[@name='crisitem']/doc:element[@name='project']/doc:element[@name='funder']/doc:element/doc:field[@name='value']"/>
                    <xsl:variable name="funderid" select="doc:metadata/doc:element[@name='crisitem']/doc:element[@name='project']/doc:element[@name='funderid']/doc:element/doc:field[@name='value']"/>
                    <xsl:variable name="grantno" select="doc:metadata/doc:element[@name='crisitem']/doc:element[@name='project']/doc:element[@name='grantno']/doc:element/doc:field[@name='value']"/>
                    <xsl:variable name="awarduri" select="doc:metadata/doc:element[@name='crisitem']/doc:element[@name='project']/doc:element[@name='awardURL']/doc:element/doc:field[@name='value']"/>
                    <xsl:variable name="awardtitle" select="doc:metadata/doc:element[@name='dc']/doc:element[@name='relation']/doc:element/doc:field[@name='value']"/>
                    
                    <xsl:variable name="check_fundingreference">
                        <xsl:for-each select="$funder">
                            <xsl:if test="$funder!='' and $funder!=$placeholder">
                                <xsl:value-of select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    
                    <xsl:if test="$check_fundingreference!=''">
                        <fundingReferences>
                            <xsl:for-each select="$funder">
                                <xsl:if test=".!='' and .!=$placeholder">
                                    <fundingReference>
                                        <xsl:variable name="counter" select="position()"/>
                                        <funderName>
                                            <xsl:value-of select="."/>
                                        </funderName>
                                        <xsl:if test="$funderid[$counter]!='' and $funderid[$counter]!=$placeholder">
                                            <funderIdentifier funderIdentifierType="Crossref Funder ID">
                                                <xsl:value-of select="$funderid[$counter]"/>    
                                            </funderIdentifier>
                                        </xsl:if>
                                        <xsl:if test="$grantno[$counter]!='' and $grantno[$counter]!=$placeholder">
                                            <awardNumber>
                                                <xsl:value-of select="$grantno[$counter]"/>
                                            </awardNumber>
                                        </xsl:if>
                                        <xsl:if test="$awarduri[$counter]!='' and $awarduri[$counter]!=$placeholder">
                                            <awardURI>
                                                <xsl:value-of select="$awarduri[$counter]"/>
                                            </awardURI>
                                        </xsl:if>
                                        <xsl:if test="$awardtitle[$counter]!='' and $awardtitle[$counter]!=$placeholder">
                                            <awardTitle>
                                                <xsl:value-of select="$awardtitle[$counter]"/>
                                            </awardTitle>
                                        </xsl:if>
                                    </fundingReference>
                                </xsl:if>
                            </xsl:for-each>
                        </fundingReferences>
                    </xsl:if>
                    
                </resource>
            </payload>
        </oai_datacite>
    </xsl:template>
</xsl:stylesheet>