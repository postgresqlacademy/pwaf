--
DELETE FROM pwaf_app_base.http_request_routes WHERE path = '/pwaf_app_base/about';
INSERT INTO pwaf_app_base.http_request_routes (id,path,controller) VALUES (1000,'/pwaf_app_base/about','pwaf_app_base.pub_controller_about');

DELETE FROM pwaf_app_base.http_request_routes WHERE path = '/pwaf_app_base/simple';
INSERT INTO pwaf_app_base.http_request_routes (path,controller) VALUES ('/pwaf_app_base/simple','pwaf_app_base.pub_controller_simple');

DELETE FROM pwaf_app_base.http_request_routes WHERE path = '/' AND controller = 'pwaf_app_base.pub_controller_root';
INSERT INTO pwaf_app_base.http_request_routes (id,path,controller) VALUES (1005,'/','pwaf_app_base.pub_controller_root');
--
TRUNCATE pwaf_app_base.gui_templates CASCADE;
COPY pwaf_app_base.gui_templates (id, description, xslt_stylesheet, code) FROM stdin;
1001	PWAF Base App Layout	<xsl:stylesheet version="1.0"\r\n    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"\r\n    xmlns:xsd="http://www.w3.org/2001/XMLSchema"\r\n    xmlns="http://www.w3.org/1999/xhtml"\r\n>\r\n\r\n<xsl:output method="xml"\r\n      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"\r\n      doctype-public="-//W3C/DTD XHTML 1.0 Strict//EN"\r\n      indent="yes"\r\n     />\r\n\r\n<xsl:template match="/*">\r\n    <xsl:variable name="schema" select="//xsd:schema"/>\r\n    <xsl:variable name="tabletypename"\r\n                  select="$schema/xsd:element[@name=name(current())]/@type"/>\r\n    <xsl:variable name="rowtypename"\r\n                  select="$schema/xsd:complexType[@name=$tabletypename]/xsd:sequence/xsd:element[@name='row']/@type"/>\r\n\r\n<html>\r\n\r\n<head>\r\n    <title>${title}</title>\r\n    <meta charset="utf-8" />\r\n    <meta name="viewport" content="width=device-width, initial-scale=1" />\r\n    <link rel="stylesheet" href="/asset/pwaf_app_base/style.css" />\r\n</head>\r\n\r\n<body>\r\n\r\n<section id="wrap">\r\n\r\n    <header></header>\r\n\r\n        <section id="content">\r\n\r\n            <div class="overview">\r\n                <ul>\r\n                    <li><a target="_blank" href="https://github.com/postgresqlacademy/pwaf">PWAF on GitHub</a></li>\r\n                    <li><a target="_blank" href="https://github.com/postgresqlacademy/pwaf/wiki">Wiki</a></li>\r\n                    <li><a target="_blank" href="https://github.com/postgresqlacademy/pwaf/issues">Bug tracker</a></li>\r\n                </ul>\r\n                <xsl:value-of select="row[2]/." disable-output-escaping="yes" />\r\n            </div>\r\n\r\n            <div class="main-content"><xsl:value-of select="row[1]/." disable-output-escaping="yes" /></div>\r\n\r\n            <div class="clear"></div>\r\n\r\n        </section>\r\n\r\n    <footer>\r\n        <div id="footer-content">\r\n            (c) 2014 postgresqlacademy.com and other contributors\r\n        </div>\r\n    </footer>\r\n\r\n\r\n    \r\n    \r\n    <div><xsl:value-of select="row[3]/." disable-output-escaping="yes" /></div>\r\n    <div><xsl:value-of select="row[4]/." disable-output-escaping="yes" /></div>\r\n   \r\n</section>\r\n\r\n</body>\r\n</html>\r\n</xsl:template>\r\n\r\n</xsl:stylesheet>	pwaf_app_base_main_layout
1004	PWAF Base App - About View	<xsl:stylesheet version="1.0"\r\n    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"\r\n    xmlns:xsd="http://www.w3.org/2001/XMLSchema"\r\n    xmlns="http://www.w3.org/1999/xhtml"\r\n>\r\n\r\n<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />\r\n\r\n  <xsl:template match="/*">\r\n    <h1>PWAF</h1>\r\n    <div style="font-size:0.8em; margin-top:-12px;margin-bottom:14px; color: #5a5a5a;">PostgreSQL Web Application Framework</div>\r\n    \r\n    <div style="margin-bottom:24px;">\r\n    <b>This is a default web page of newly setup PWAF installation.</b>\r\n    \r\n    </div>\r\n    \r\n    \r\n    <div style="margin-bottom:24px;">\r\n    \r\n        <h3>Existing applications:</h3>\r\n    \r\n        <table style="font-size:0.9em">\r\n            <xsl:for-each select="row">\r\n                <tr>\r\n                    <td>    \r\n                        <a target="_blank">\r\n                          <xsl:attribute name="href">\r\n                          <xsl:value-of select="concat('',./default_path)"/>\r\n                          </xsl:attribute>\r\n                          <xsl:value-of select="./name"/>\r\n                        </a>\r\n                    </td>\r\n                </tr>\r\n            </xsl:for-each>\r\n        </table>\r\n    <br /><br /><h3>Misc:</h3><ul style="font-size:0.9em;"><li><a href="/pwaf_app_base/simple">Simple controller (without XSLT)</a></li></ul>\r\n    </div>\r\n    \r\n     \r\n  </xsl:template>\r\n\r\n</xsl:stylesheet>	pwaf_app_base_about
\.
--
TRUNCATE pwaf_app_base.gui_layouts CASCADE;
COPY pwaf_app_base.gui_layouts (id, template, code) FROM stdin;
1002	1001	pwaf_app_base_main_layout
\.
--
TRUNCATE pwaf_app_base.gui_views CASCADE;
COPY pwaf_app_base.gui_views (id, template, layout, code) FROM stdin;
1003	1004	1002	about
\.
--

TRUNCATE pwaf_app_base.assets CASCADE;
COPY pwaf_app_base.assets (id, content_type, data, name) FROM stdin;
1005	text/css	@charset "utf-8";\r\n/* CSS Document */\r\n\r\n/* http://meyerweb.com/eric/tools/css/reset/ \r\n   v2.0 | 20110126\r\n   License: none (public domain)\r\n*/\r\n\r\nhtml, body, div, span, applet, object, iframe,\r\nh1, h2, h3, h4, h5, h6, p, blockquote, pre,\r\na, abbr, acronym, address, big, cite, code,\r\ndel, dfn, em, img, ins, kbd, q, s, samp,\r\nsmall, strike, strong, sub, sup, tt, var,\r\nb, u, i, center,\r\ndl, dt, dd, ol, ul, li,\r\nfieldset, form, label, legend,\r\ntable, caption, tbody, tfoot, thead, tr, th, td,\r\narticle, aside, canvas, details, embed, \r\nfigure, figcaption, footer, header, hgroup, \r\nmenu, nav, output, ruby, section, summary,\r\ntime, mark, audio, video {\r\n\tmargin: 0;\r\n\tpadding: 0;\r\n\tborder: 0;\r\n\tfont-size: 100%;\r\n\tfont: inherit;\r\n\tvertical-align: baseline;\r\n}\r\n/* HTML5 display-role reset for older browsers */\r\narticle, aside, details, figcaption, figure, \r\nfooter, header, hgroup, menu, nav, section {\r\n\tdisplay: block;\r\n}\r\nbody {\r\n\tline-height: 1;\r\n    min-width: 1000px;\r\n}\r\nol, ul {\r\n\tlist-style: none;\r\n}\r\nblockquote, q {\r\n\tquotes: none;\r\n}\r\nblockquote:before, blockquote:after,\r\nq:before, q:after {\r\n\tcontent: '';\r\n\tcontent: none;\r\n}\r\ntable {\r\n\tborder-collapse: collapse;\r\n\tborder-spacing: 0;\r\n}\r\n\r\nh1, h2, h3, h4, h5, h6{\r\n\tcursor: default;\r\n}\r\n\r\n\r\n/*reset ends*/\r\n\r\nbody{\r\n    background-color: #F0F0F0;\r\n    font-family: Arial, sans-serif;\r\n}\r\n\r\nheader{\r\n    width:100%;\r\n    height:50px;\r\n}\r\n\r\nsection#content{\r\n    width: 960px;\r\n    margin: 0 auto;\r\n    padding: 25px 0 20px 0;\r\n}\r\n\r\nfooter{\r\n    background:#3B3C3A;\r\n}\r\n\r\n#footer-content{\r\n    width:960px;\r\n    margin: 0 auto;\r\n    font-size:0.75em;\r\n    color:#fff;\r\n    padding:25px;\r\n}\r\n\r\n.overview {\r\n    width: 220px;\r\n    float: left;\r\n    min-height: 100px;\r\n    margin-right: 16px;\r\n    padding-top:25px;\r\n}\r\n\r\n.main-content{\r\n    width: 654px;\r\n    float: left;\r\n    background-color: white;\r\n    min-height: 500px;\r\n    border-radius: 6px;\r\n    box-shadow: 0 0 7px #DADADA;\r\n    padding: 33px;\r\n}\r\n\r\n.main-content h1 {\r\n    color: #39444A;\r\n    font-size: 36px;\r\n    margin-bottom: 8px;\r\n}\r\n\r\n.clear{\r\n\tclear:both;\r\n\twidth:100%;\r\n}\r\n\r\n.overview ul li a {\r\n    text-decoration: none;\r\n    color: #686868;\r\n    line-height: 40px;\r\n    width: 100%;\r\n    display: block;\r\n    border-bottom:1px solid #d4d4d4;\r\n}	style.css
\.

