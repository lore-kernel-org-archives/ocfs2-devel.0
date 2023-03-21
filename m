Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9236C7EE2C
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CwfnrXhXf0lmvB+Ojz2c1GeiCB0lwCcdCeNUJHL5sKw=;
 b=MAR0eLy+1a5gYgOv00SJ+aWTbE+pd0O+4yunTV/lE+Vw1LIge/gJYFtHdyThtlBFHgLR4q28apK7
   PENZjUSaeBJh/RJr6cBmUjEWRzo8yvjS4dXEtqLf8TQp4bKZEMEwswpL6g271K6J4N5b0uNPeLkw
   EjVfApNba+jcodkciX4EgG3YtnBmNFvdTSwj4gPFwTd7mQafzN2QbOfpO4rdNRIZR/zSlynfPrAJ
   asZwbTZHYzygdciPDkEoJhLRvN3z/AQYtkMJuhSsGvN79RXfghxWVocxrht4eXDo4MxDdGklOkRW
   1eOGMXA6q2F8DQ8zt4jFlZ0F4azgD2GyGnp4xg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CwfnrXhXf0lmvB+Ojz2c1GeiCB0lwCcdCeNUJHL5sKw=;
 b=m1KckoeJcvRTl6lBMKO7OY95UIgCbPv6pcVXqdzSGEpIi0y8h7up6ZJZ5woycAjMyKfYVdtS6Tk/
   DjHnGvpDfB2fiC8MNZbjwJgrgPnQjD5CFOE9elGxMVDSCpPHLNxlnrU0F4NC1M46Qd7+YFD0RSMw
   VNvBBSFQKetSeke1W+RBtjN8XApjCwznQrTGzv7v5UUUDu1jCbQ094nxqsAPn+Wcl86awet39ITO
   quDLj++cChyqbTnKscO9AMy072wAIFPDpnmNoQ9Rc1boWw6RH3x7XRj4lLUrjo98qUS3Drux3SJQ
   e8FBAiZlBAC5Uv7/A+VaG0p7dS72yLhUKmQgsw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX0076OM1A6C50@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 t=1679364804;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=+aru+LE4EXkeavSro1pWZfyN/YO+OmTYPczjGb5OpGs=;
 b=Bq7TXmOAJ2TfbOMoXQht2qvX6iaeJdNSu0CKGNIbtaKYyoxpLaASa9Ld2V4Q5rdwqs
 3ZrkL6ruhabcNEDgmryoXVn2bERGABCj6eArK5HvqWdGfoOp/0oXfnXZpkJXlFsSm6ta
 oujEbQPraAtv3lktwona5Sje1Y+Xr/tjFpDjewgQBBISRLpJTEL62tAkVpk1Y7HQtJc0
 +5qeExO7GZe7qN2IP78qU817ZTT2v63B+n9OQPpf7ce4zAI7we4cSGE7dNmvfsovsupd
 FWAjlL5OW6J5OlRS0z/cw0txct1eUOH2bm3PhWH0lBkSZmZ2vKvHhqXkpSOA1SLSi9HD QO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; t=1679364804;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to; bh=+aru+LE4EXkeavSro1pWZfyN/YO+OmTYPczjGb5OpGs=;
 b=CC5gR3ppe6EwSyQwNx6lEGHYvpB61jsmEyZFHG10AF8KvCv8ZvhhklX17bnalx+H98
 y8SHDSIvwk9f3jSgrozRWYSAiXszlgfR3sOqtvVOQI2OK1OYHuq5zGJAwa2Hp3wz2fIq
 0pcSZ4jh6DGOAJluSEGkv7Lw8RP9yUwbqyOTVt+LCbVQqeMC9psevry8i/zDHzOcF9Xe
 Q5BC/XOpCfeh1EKLSG+DPS5S2pJviz8tBe6yTlUJ7AhS16+tpCC0WTkELaRWMoA6XkTY
 y+y4NjASiGMdWbIsmzMhzxO+WSwKbJecP8KHxUI1TV61+jDFhYH4zPSGm+F/h8TetTj7 uGdw==
X-Gm-Message-State: AO0yUKW+/otBOczFndJD85h9dtujLdUTUyhiEmYEDkY2+oveb7KVV5XP
 ci65GnXSkfvdRRRHN3ncgH0=
X-Received: by 2002:a17:902:ea10:b0:1a0:549d:3996 with SMTP id
 s16-20020a170902ea1000b001a0549d3996mr1431081plg.25.1679364804150; Mon,
 20 Mar 2023 19:13:24 -0700 (PDT)
Date: Tue, 21 Mar 2023 09:13:20 +0700
To: Joseph Qi <jiangqi903@gmail.com>, gregkh@linuxfoundation.org,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org, gechangwei@live.cn,
 ghe@suse.com, jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, mark@fasheh.com, piaojun@huawei.com,
 stable@vger.kernel.org
Message-id: <ZBkSwL37/9DpfnvP@debian.me>
References: <1679313445246112@kroah.com>
 <63069869-30cf-c45f-3b05-b0b9b46bc36a@gmail.com>
MIME-version: 1.0
In-reply-to: <63069869-30cf-c45f-3b05-b0b9b46bc36a@gmail.com>
X-Source-IP: 209.85.216.53
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10655
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 clxscore=-49 phishscore=0
 mlxscore=0 mlxlogscore=794 suspectscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210018 domainage_hfrom=10082
Subject: Re: [Ocfs2-devel] FAILED: patch
 "[PATCH] ocfs2: fix data corruption after failed write" failed to apply to
 5.10-stable tree
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
From: Bagas Sanjaya via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Bagas Sanjaya <bagasdotme@gmail.com>
Content-type: multipart/mixed; boundary="===============2753646105182239333=="
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AK7set857l+AUzpri2yHQOlAiVSSITyZ7FxL1EHGrN2CYgnclIFGmclMhx4QGycWAfdenQ68k8Tejw==
X-ServerName: mail-pj1-f53.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: 45t4oSY1ELscQadsm1o1wERnT6KZpuxa
X-Proofpoint-ORIG-GUID: 45t4oSY1ELscQadsm1o1wERnT6KZpuxa
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAGJeDVO72egaV676fWS7bh/Pn5ujwDHo5TjvGDjt4pKpTVTbbblFY3MGumG7+Iv
 z7Yfrsx+6X++ClHEb5dmHy3OhAgkNX6o750U44f1j5dYK6yzyiLJBhaaMZiX23gB
 PETWLOaJlA/U+LwVI+wJOrDTXKA5QoANr+sc4D/5kgzK0XvN6DE+10iQYWSaGtXt
 yHO8WrWkNm0HNH/wUYzsgcL6oKh9/7Tr2XnfjosHdO0NJErNIISws/h9wYwawDXh
 54K0uYQ/OM4k6JRsRfu+uznb5Dr699B/Sx5/vyrWWUWGhSd2ggsVxrtuFKciZoqa
 FvZ4ncfeX5HAPmcSJ9aXhMSpPTkbuFj8Pf46tKvUI7UjBR+YWtWIRbodYgJ61zhX
 t1tcy/m4rBVwFn1s4M8i2EkRVNarTCsO4Djshp500zwbd7EPX6G6Y7cX9tvQt+zj
 cZm9Aaf4Ufy32cgumOm2XMa5LHg4sEmcJ7LzWT4cdLHONr/musaPi2E482H9e1fW
 Oua9LrdtbjCGquTKmVx6i7kvlgVpczCcOhA6MHdZ7Sv0Xw==


--===============2753646105182239333==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4XH3fd8OGZLBNYfL"
Content-Disposition: inline


--4XH3fd8OGZLBNYfL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 21, 2023 at 10:06:30AM +0800, Joseph Qi wrote:
> Hi Greg,
> It can be cleanly applied for linux-5.10.y and linux-4.19.y in my desktop.
> I'm not sure how it happens.
>=20

If you can apply the backport, why don't you post it here?

--=20
An old man doll... just what I always wanted! - Clara

--4XH3fd8OGZLBNYfL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBkSuAAKCRD2uYlJVVFO
oz8tAP9ajyDoskGN+cc/C/Qf7rPBXQEISy5oRe1wUZg89JY6CwEA3u8AcptsC/7U
TUUt28jkOWlOzrByYESgEI3W9Uwz8w8=
=lXl3
-----END PGP SIGNATURE-----

--4XH3fd8OGZLBNYfL--


--===============2753646105182239333==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============2753646105182239333==--

