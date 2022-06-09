Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11BF9C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Jun 2022 19:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=s4Nf8Np/Cnch79XPbJTkx65OhbOnEsorhpr/LztKvTk=;
 b=dfF8AVGMMMQiQwlYfCjzoCq0FQhCt7uNKeGr9UHVxiW6xG85dFMteaNx/T0OnPOMjBpzHQvtDRRJ
   H7fGXVe2rjbe2e2N4Ato/xxoz2TGxH+wNLOCPP7t4g2i8qrAfB/3i7rAk4cXETLHFxy0aVAPJK3W
   T+15W8BHDx0mrYjQI3cxOzpDzIT8/p50Mbv1DjdacbuyMGgR4LgFq/3+mXXra4gY1NkQSehXhxg8
   SUitRXBw8VtBbo6KXfKaeFjE5vwrP91/FXb5amSsCd78cxI2dUBEA45ZpLF87H+HOHiNvhRn/ajf
   jRbbBzAV4rb8KLBVXMqeQJW+EUyHv1TCKMCj5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=s4Nf8Np/Cnch79XPbJTkx65OhbOnEsorhpr/LztKvTk=;
 b=Ag2+ZOA6RSZY2KcXjX82d2qjQ65kXsXHgcD+TLBrIqkvfogY6efNQ7AapQ6+JukDdR8aAp/AsLo+
   WBb0RWoHHVgXOYDf+KN/dA3A6Yet9kMbIucbLGadRP9mnnxOzyB/PbDDfIyThDRQ7X9Cg/IBxiwp
   SyGynR5Riseg+dYA1MSoAatGq9QTEvVlGwQMPjgks85ZbmiZlFAb8NDyd/5rMWMj6p0y1mpn4SBe
   09RoIY+pviy74pibvwnBN0bec7dZHrNYD5enYb6us4V6T9PHFmoBRvT9dplEv73u1gRiE7tGDKXZ
   3Y9UXYtVDg4yuDI8AaiM90iwQedJjEI67jufZg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD800BJK5NDQK40@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 09 Jun 2022 19:18:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=helmholtz-muenchen.de;
 s=C0F30F38-B250-11EB-A191-7CCD3589A052; t=1654802311;
 bh=dDF7ly8sHVtaC5QXEJFVul4+Ve/W1XEiwxLzakiLXpw=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=Cx7nePlhn+3An3TVncsX2GuM+3ZgBUdDfMCm5XmSioNzxDxGYFpUVUP3l+SftjPHP
 TdnP0rMAQlLxppa+hDtE3mmqHs9Cx1xoO5+pJDgQWFgUH+fwchetqbwC7EqbOqHdwG
 /0hWDJt2HUQS5Dx/M1Ia9qS8y5+7ftEIjEviBV+mNgi3HpcfBkQPTXniDx4iUjCiiQ
 gS8Ld7nA57rhs5xYhJDGdV7ziLiXE1DtdAoJSxGF/tzAQrvlhJ1EiZl0FozbtLjpmz
 MU9RaAO4py2R04ZZ4CzWSgkz4nO0kRTwVFNQia2f4YwbH9GmMGyKZHJuxiasJzZ7Id
 SoV4OjhkljxSA==
X-Virus-Scanned: amavisd-new at mtaextp1.scidom.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=helmholtz-muenchen.de;
 s=C0F30F38-B250-11EB-A191-7CCD3589A052; t=1654802313;
 bh=dDF7ly8sHVtaC5QXEJFVul4+Ve/W1XEiwxLzakiLXpw=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=t9Quv7/7nTwpsoyV5xQCypUsY51bzRUYuontZXYI3LKZkVwe01cdC4TPIrMxIvnzK
 cnQosA8hchP7CCbXDYVtk8VUNdpG9TU9Bdn721cRel+Bx6ALqgXDjM5D1FbD8cSEQ+
 iQBcPis3GzJHh0I7S3UgOf+155Od2u6MOSHYLgub4x+BQ47eMWVTnhtQvM0VLQYkQf
 TVtl13txeasdHS4dybFyh8pPrvoo8nz8tsWj/ksBP9cghCVPklzS6Ubzx+kwwfCatw
 6EkOY5JMApcJZYTkZVixDj+Ax5+hUFTQkitrd68PmnnxLuzFXySMxqUvgntWinHV9R
 qW9wFdWti8Kmg==
X-Virus-Scanned: amavisd-new at mtaintp1.scidom.de
Date: Thu, 9 Jun 2022 21:18:32 +0200 (CEST)
To: ocfs2-devel ML <ocfs2-devel@oss.oracle.com>
Message-id:
 <1021341868.90919485.1654802312953.JavaMail.zimbra@helmholtz-muenchen.de>
MIME-version: 1.0
X-Originating-IP: [146.107.158.196]
X-Mailer: Zimbra 8.8.15_GA_4203 (ZimbraWebClient - GC102 (Win)/8.8.15_GA_4232)
Thread-index: xay093f5POxWkM8KU5qpTcYdxp9NBg==
Thread-topic: how to restore a reflink ?
X-Source-IP: 146.107.3.202
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10373
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 mlxlogscore=992 spamscore=0 bulkscore=0 malwarescore=0 mlxscore=0 clxscore=98
 impostorscore=0 adultscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206090071
Subject: [Ocfs2-devel] how to restore a reflink ?
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: "Lentes, Bernd via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
Content-type: multipart/mixed; boundary="===============3108278408169326594=="
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaextp1.scidom.de
X-Amavis-Modified: Mail body modified (using disclaimer) - mtaintp1.scidom.de
X-ServerName: mtaextp1.scidom.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 a:mtaextp1.helmholtz-muenchen.de
 a:mtaextp1.scidom.de a:mta01.helmholtz-muenchen.de
 a:mta02.helmholtz-muenchen.de include:_spf.zimpel.de ip4:146.107.3.202
 ip4:146.107.3.101 ip4:146.107.4.101 ip4:78.47.106.36 ip4:78.47.106.37 ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: GP1VDoebV1P22VG1Zp6Xe6dAN6xtNe-f
X-Proofpoint-GUID: GP1VDoebV1P22VG1Zp6Xe6dAN6xtNe-f
Reporting-Meta:
 AAGrHWop3vmzTaVI1bBriGvXh6HgkFl0vm34El6vhWiI7qZLS/WlNGwtuWU5y2bF
 R+7fcMBFEGH+kgHdx4dVfDSJn8emrpGxhZRcDjpcHFHx3d+Ps2KwDrLWse2+CrfI
 gKjXGC2JKIf5bWPwiTKW+nteFHtLsS4xSP+YmQVC78P9Fv4vXoKuPiu6P6ZaiLul
 IZO43KvOIMHcZQvtPtcqwhiJ8XYucTrv1Zb2fWCMGYYPuWLsXvK2YeEkRXpxdKAd
 PJNUFWHnHYq/tp4t9EINLcfwJAv+eaHa/F1vK7p8ikJcexr1Y712D8843ItcQMWD
 1Stn2I9MutRM6oyazNTn8ajY5ri83Qsh4ZgY/RdzeZziklP5gRbkq+OHrflc0Aze
 CpIb078j/cE9JK25zm4whkkcmPE3Syar7p5wTh9P4Yypodfznb2xrCDL/UpJubdA
 +d7tw5EJ+FHtjrqpKnZ1bF5RKVXtDLoxBJmjl+8sZWPuOmAL3qJPsiFnUG+QxBSI
 sLxkh+CJ8Bcxe/nn7u6Xxpjmv9joUKgTxFWUxCt3Q1jU
DKIM-Filter: OpenDKIM Filter v2.10.3 mtaextp1.scidom.de 221BB18052B6A
DKIM-Filter: OpenDKIM Filter v2.10.3 mtaintp1.scidom.de 70E9A825324F

--===============3108278408169326594==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; 
	boundary="----=_Part_90919487_175018268.1654802313280"

------=_Part_90919487_175018268.1654802313280
Date: Thu, 9 Jun 2022 21:18:32 +0200 (CEST)
From: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
To: ocfs2-devel ML <ocfs2-devel@oss.oracle.com>
Message-ID: <1021341868.90919485.1654802312953.JavaMail.zimbra@helmholtz-muenchen.de>
Subject: how to restore a reflink ?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [146.107.158.196]
X-Mailer: Zimbra 8.8.15_GA_4203 (ZimbraWebClient - GC102 (Win)/8.8.15_GA_4232)
Thread-Index: xay093f5POxWkM8KU5qpTcYdxp9NBg==
Thread-Topic: how to restore a reflink ?

Hi,

i have some Virtual machines running on an OCFS2 volume.=20
That means that their disk images reside on an OCFS2 volume.
I needed to change something inside one vm and created a relink of it befor=
e.
What i wanted to change went wrong. I need the reflink.

I have vm.raw and vm_before_configure.raw.
vm_before_configure.raw is my reflink.
The files are quite big: 280 GB.

My planned procedure is:
Stop Virtual machine.
Copy vm_before_configure.raw somewhere else to vm_before_configure.raw.bak.
Delete or rename vm.raw
Rename vm_before_config.raw.bak to vm.raw
Start the VM again.
Hopefully be happy.

Is that ok ?

Bernd
--=20

Bernd Lentes=20
System Administrator=20
Institute for Metabolism and Cell Death (MCD)=20
Building 25 - office 122=20
HelmholtzZentrum M=C3=BCnchen=20
bernd.lentes@helmholtz-muenchen.de=20
phone: +49 89 3187 1241=20
fax: +49 89 3187 2294=20
http://www.helmholtz-muenchen.de/mcd=20


Public key:=20

30 82 01 0a 02 82 01 01 00 b3 72 3e ce 2c 0a 6f 58 49 2c 92 23 c7 b9 c1 ff =
6c 3a 53 be f7 9e e9 24 b7 49 fa 3c e8 de 28 85 2c d3 ed f7 70 03 3f 4d 82 =
fc cc 96 4f 18 27 1f df 25 b3 13 00 db 4b 1d ec 7f 1b cf f9 cd e8 5b 1f 11 =
b3 a7 48 f8 c8 37 ed 41 ff 18 9f d7 83 51 a9 bd 86 c2 32 b3 d6 2d 77 ff 32 =
83 92 67 9e ae ae 9c 99 ce 42 27 6f bf d8 c2 a1 54 fd 2b 6b 12 65 0e 8a 79 =
56 be 53 89 70 51 02 6a eb 76 b8 92 25 2d 88 aa 57 08 42 ef 57 fb fe 00 71 =
8e 90 ef b2 e3 22 f3 34 4f 7b f1 c4 b1 7c 2f 1d 6f bd c8 a6 a1 1f 25 f3 e4 =
4b 6a 23 d3 d2 fa 27 ae 97 80 a3 f0 5a c4 50 4a 45 e3 45 4d 82 9f 8b 87 90 =
d0 f9 92 2d a7 d2 67 53 e6 ae 1e 72 3e e9 e0 c9 d3 1c 23 e0 75 78 4a 45 60 =
94 f8 e3 03 0b 09 85 08 d0 6c f3 ff ce fa 50 25 d9 da 81 7b 2a dc 9e 28 8b =
83 04 b4 0a 9f 37 b8 ac 58 f1 38 43 0e 72 af 02 03 01 00 01

------=_Part_90919487_175018268.1654802313280
Content-Type: application/pkcs7-signature; name=smime.p7s; smime-type=signed-data
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCAMIIF
yDCCBLCgAwIBAgIMIgdroMAv99uEUtszMA0GCSqGSIb3DQEBCwUAMIGNMQswCQYDVQQGEwJERTFF
MEMGA1UECgw8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdz
bmV0emVzIGUuIFYuMRAwDgYDVQQLDAdERk4tUEtJMSUwIwYDVQQDDBxERk4tVmVyZWluIEdsb2Jh
bCBJc3N1aW5nIENBMB4XDTE5MTIwNDE3MzQwOVoXDTIyMTIwMzE3MzQwOVowVzELMAkGA1UEBhMC
REUxIzAhBgNVBAoMGkhlbG1ob2x0eiBaZW50cnVtIE11ZW5jaGVuMQwwCgYDVQQLDANJREcxFTAT
BgNVBAMMDEJlcm5kIExlbnRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALNyPs4s
Cm9YSSySI8e5wf9sOlO+957pJLdJ+jzo3iiFLNPt93ADP02C/MyWTxgnH98lsxMA20sd7H8bz/nN
6FsfEbOnSPjIN+1B/xif14NRqb2GwjKz1i13/zKDkmeerq6cmc5CJ2+/2MKhVP0raxJlDop5Vr5T
iXBRAmrrdriSJS2IqlcIQu9X+/4AcY6Q77LjIvM0T3vxxLF8Lx1vvcimoR8l8+RLaiPT0vonrpeA
o/BaxFBKReNFTYKfi4eQ0PmSLafSZ1Pmrh5yPungydMcI+B1eEpFYJT44wMLCYUI0Gzz/876UCXZ
2oF7KtyeKIuDBLQKnze4rFjxOEMOcq8CAwEAAaOCAlswggJXMD4GA1UdIAQ3MDUwDwYNKwYBBAGB
rSGCLAEBBDAQBg4rBgEEAYGtIYIsAQEEBDAQBg4rBgEEAYGtIYIsAgEEBDAJBgNVHRMEAjAAMA4G
A1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwHQYDVR0OBBYEFIbj
udERXYhU7DMaI17GPlWqLTQVMB8GA1UdIwQYMBaAFGs6mIv58lOJ2uCtsjIeCR/oqjt0MC0GA1Ud
EQQmMCSBImJlcm5kLmxlbnRlc0BoZWxtaG9sdHotbXVlbmNoZW4uZGUwgY0GA1UdHwSBhTCBgjA/
oD2gO4Y5aHR0cDovL2NkcDEucGNhLmRmbi5kZS9kZm4tY2EtZ2xvYmFsLWcyL3B1Yi9jcmwvY2Fj
cmwuY3JsMD+gPaA7hjlodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2Rmbi1jYS1nbG9iYWwtZzIvcHVi
L2NybC9jYWNybC5jcmwwgdsGCCsGAQUFBwEBBIHOMIHLMDMGCCsGAQUFBzABhidodHRwOi8vb2Nz
cC5wY2EuZGZuLmRlL09DU1AtU2VydmVyL09DU1AwSQYIKwYBBQUHMAKGPWh0dHA6Ly9jZHAxLnBj
YS5kZm4uZGUvZGZuLWNhLWdsb2JhbC1nMi9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwSQYIKwYBBQUH
MAKGPWh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZGZuLWNhLWdsb2JhbC1nMi9wdWIvY2FjZXJ0L2Nh
Y2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAG9FaTFBh6Yp8cNfWoaMF6GhZRFiARkPSNlvI8BJ
y+tS5W9urRKluF0mtgseNk1Eff3AD1bqicMIzThTuScwq1WhY5ZCGlD/qYLf+FY3VnPTjk6ZVruE
KuoA4bKJaVrXGkfBmw+oSMh6rfw6pwnchLXP7l40hDQ5tQ2/8BcpZYcykC4ziIga3hqe7vN4vhF6
gYKN6lET83QXYoh0IGCfFw3fIdTJk1IStMqe0Cd7eXpfwKQfjtzK8M5Qccj46923WGIwo0zSRiJR
R1J97qDZZxBsGJfj3tC5X/FkWhn3fDiPZYeTlvmFrzSyLSw/FBR/D2o/bUz+eaeVmenc32vxYmEA
ADGCApswggKXAgEBMIGeMIGNMQswCQYDVQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1ciBGb2Vy
ZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLDAdE
Rk4tUEtJMSUwIwYDVQQDDBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBAgwiB2ugwC/324RS
2zMwDQYJYIZIAWUDBAIBBQCggc4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjIwNjA5MTkxODMzWjAtBgkqhkiG9w0BCTQxIDAeMA0GCWCGSAFlAwQCAQUAoQ0GCSqG
SIb3DQEBCwUAMC8GCSqGSIb3DQEJBDEiBCD0YdvoIfWLq9DoaidmngOPsulIUoseKQE5d/e+d4Xc
KzA0BgkqhkiG9w0BCQ8xJzAlMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDAHBgUrDgMCBzAN
BgkqhkiG9w0BAQsFAASCAQCQ8Kje6pzZw3tTzdkyjDfX963+kMH8wIRvblGY0+AjcpALym5kmePj
8S/AmyOUyVP69oOCnTbOb8b0/gq/OH2Fm2M6h9t1aFXiGYjkuaMoM4NwtBCah2A0+m8OY2P3B2d2
Im3lKz34vba3HosXoSpOe9kXzC6YX7TUB3lcq21d8Xrdtwn/yq+gM2DrprdjBk85WVzj2sZ8WPXo
9CDb8DPVjT1TmiB2wIL2qOiX6qwGvcm8kYCntxut/LTEeIZdff2ceBUA4K4qxL24cCWO9JvY/LN3
hQn8utY3cgk/Q4Oh0ANRdAc9ZOwbhqmkcdOY+treznjuTiuZKCwPh2D3L0G3AAAAAAAA
------=_Part_90919487_175018268.1654802313280--


--===============3108278408169326594==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============3108278408169326594==--

