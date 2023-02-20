Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2393C05027
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Feb 2023 11:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6op94G/80abpZnlfzFYJiXknPqhfWxYWVohd19cgRo8=;
 b=mAzKM3bRfWmRMkhNTviB8S4voV+5lIuflU8yw82P+LC0S0UrsD7g/On1MxonBXW2/WcleUjday52
   nBM6z9QN4QUWjiT2e56xSzWTcRCjfLbfEg1j4EOHI4x4gzZMwn4+vU948rSh0/4qCFv4q6QZxqa6
   o7Y6Eo+KMKoZkfKPVWtPahbot2ijCCAvugWEpRtSkUytt+zWtPjmI/IUmkoB4c397qGTtQ/Nowya
   hw/U3BT+WU0fNbVA0v53tn1xQo3LVLMwGL7TPDtQGcwv4+T+CGFVkmL9rka3i8KdnWahHKAv8L+w
   0bFwbhinNcZekaQkIBELaEAzVuGhXoM5K1R+Lw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6op94G/80abpZnlfzFYJiXknPqhfWxYWVohd19cgRo8=;
 b=CTnKfwz4QZ0FhZ5vlru4Rh/P7ka1z5qQQYYNK3HjIxl+psgfYP9h4uG9zht4KIPkV1r4S1qGFTIl
   QrLVdPo4rawWmRGghD2IpP3kYjQAlBXtQaXI0/Axc8L6t7wLy0KTfDgL3HrXWPid/0oMySM9P/Qy
   X74HHluA66ZfPqoT5HIGLHfgoiFoqwA4ms0Fz65Jbj61KJqePFQngLTbmyGMKXUlk6gbRJNdH9V1
   i+IMH115gj1JTU9d0U/EXSatPSjWlYg8EqMvq8V6PBn4mlNY+1DgzhIzv7Bgy+55gmvSB9vVjaV2
   wJNTOR5TVrycW/wAAryPHoYaCD+w8s2mhgBRGg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQD00FXDLO8DE40@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Feb 2023 11:09:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=iaff3ymAW5HS/2O66xYNAHjFL1PE3JHi2WMFx/EOoTU=;
 b=gGXn0ElsRvpMwlsc3zR4Nb+UQaretD+157EGIQ4UtgX8oR3+XPvJmaaLtfm1fkNCRBlP
 Y2HcHjhzlbisyNy9PNLv+0B8uMss+3b0mFBtj8VOrAxzwimmsAXoEV551kvchJKSxjQQ
 G9R8W9PdBIECBY3PwwgSu5zR/vjucaQYfaKjiqZOBAh+DC+yZA5C8dWB+IlGlBzEpRyp
 R7Q3No76DQP3YYzofJEp24qBC6fViy2wyc1+AupZ1oZ8smXIkjpErQH4J0ZTjCf/Bofg
 CghLsHWLmdWovYY3T/A15rALxH+14Jyne0Etw5ttORvmKKoq0mWHw28RHuT/DSeqG3cq /w==
Message-id: <1e93d7b299de3b6cf61b5a5c4be91eb47d864ac6.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Mon, 20 Feb 2023 06:08:59 -0500
In-reply-to: <95f9b1dfca0cbff1c6a447dde45c2f835bc1a254.camel@huaweicloud.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
 <a20a6d84d8e682fbff546b80eda75a1918d7c108.camel@linux.ibm.com>
 <aaeee7490cfee1b2163a3c9c894294aaf13e100c.camel@linux.ibm.com>
 <95f9b1dfca0cbff1c6a447dde45c2f835bc1a254.camel@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-20_08,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0 impostorscore=0
 phishscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200100
X-Source-IP: 148.163.158.5
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=80
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=160 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200100
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 2/6] ocfs2: Switch to
	security_inode_init_security()
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
From: Mimi Zohar via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Mimi Zohar <zohar@linux.ibm.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-TM-AS-GCONF: 00
X-ServerName: mx0b-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: JJrhO66RT2Ec3jAiJZ3Ap5E2X5oU5Q42
X-Proofpoint-GUID: JJrhO66RT2Ec3jAiJZ3Ap5E2X5oU5Q42
Reporting-Meta:
 AAFQ+pLcL9zCN0v7is2VocRi6zOGn8Ydx9Zl/FibLdpYMTRIBSwPO9Vgj4oJuS3Y
 XV061YTO6S+xAfU3bckJdtwpulQb8iMGxHf87Tldr/tIgdlRWOS6J5RDFZBxyV3c
 01wFMEWidO3JINuBXpJo5JCNBIQ/OuPYjoNhN1GWkZEZVFBZpDM+MpsmuFDwc1lU
 Us+ccTgSZPPDtj38JeCVR+Up9/PtYqU40lK0Mvareki6J3sAzf5C30xR69hoHoMr
 jw/5azIT33Wg/K/brxSC1LBIWo3E4gPKEKL6MPj9wabbNioDEiiRhZgC2OIIaLIt
 T37P59kLzTy+3vUifa95yzbdjQJBB4qJ7oSGwk7lFnSliScvCnbJk1oyU3jc7DmY
 kSW4n75ZMPJnHdONCQ0sfXy73zxNM8evTyYBXTDJcckQTaE5IowDUBti/vxOogiJ
 puDBosx33g7fThI5VyDNDIaaIkI/qEjMNN43pgCMZwROFqoIh1e4jkfFY4qgFX9a
 qh63T7T4fN0+oGrKoJoh4jYiG2tzZVJRt1CH6X4z5ct0

> > > > diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> > > > index 95d0611c5fc7..55699c573541 100644

> > > > @@ -7277,13 +7289,23 @@ int ocfs2_init_security_get(struct inode *inode,
> > > >  			    const struct qstr *qstr,
> > > >  			    struct ocfs2_security_xattr_info *si)
> > > >  {
> > > > +	int ret;
> > > > +
> > > >  	/* check whether ocfs2 support feature xattr */
> > > >  	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
> > > >  		return -EOPNOTSUPP;
> > > > -	if (si)
> > > > -		return security_old_inode_init_security(inode, dir, qstr,
> > > > -							&si->name, &si->value,
> > > > -							&si->value_len);
> > > > +	if (si) {
> > > > +		ret = security_inode_init_security(inode, dir, qstr,
> > > > +						   &ocfs2_initxattrs, si);
> > > 
> > > The "if (unlikely(IS_PRIVATE(inode))"  test exists in both
> > > security_old_inode_init_security() and security_inode_init_security(),
> > > but return different values.  In the former case, it returns
> > > -EOPNOTSUPP.  In the latter case, it returns 0.  The question is
> > > whether or not we need to be concerned about private inodes on ocfs2.  
> > > If private inodes on ocfs2 are possible, then ocsf2_mknod() or
> > > ocfs2_symlink() would fail to create the inode or symlink.
> > 
> > Correction, previously when returning -EOPNOTSUPP for private inodes,
> > xattrs would not be wrriten.  By returning 0 without setting si->enable 
> > to 0, xattrs will be written.
> 
> Ok, but if there is a private inode, we would be setting si->enable to
> zero. Should be ok, I guess.

si->enable is being set to zero, below, but is conditional on !si-
>name.

This is the last concern, otherwise the patch set looks good.

> > > > +		/*
> > > > +		 * security_inode_init_security() does not return -EOPNOTSUPP,
> > > > +		 * we have to check the xattr ourselves.
> > > > +		 */
> > > > +		if (!ret && !si->name)
> > > > +			si->enable = 0;
> > > > +
> > > > +		return ret;
> > > > +	}
> > > >  
> > > >  	return security_inode_init_security(inode, dir, qstr,
> > > >  					    &ocfs2_initxattrs, NULL);
> 
-- 
thanks,

Mimi


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
