<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0"/>
	<xsl:param name="nomElement">Nom_Element</xsl:param>
	<xsl:param name="valCible">Valeur Cible</xsl:param>
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="name()=$nomElement"><xsl:value-of select="$valCible"></xsl:value-of></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="@* | node()"/>
				</xsl:otherwise>	
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
