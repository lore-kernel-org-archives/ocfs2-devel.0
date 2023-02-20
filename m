Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65DF7C05027
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Feb 2023 12:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sw+7rLeolz/OBNBOgh1u1sceFWmzxRJZviQxzYYI4RY=;
 b=xA2otwvIqgu6sc2UeKC0T4b2MWC/zW+tN7F/qlqGApxfOU2jRjpyE087f3wSwPqwX2AMsvLj6A3m
   565BASyaeUfnfn8Uy3jWqE4t6GIqGpsJZM1JmmDI0Kz40TE7M2vrJ3gNHhYTwjlQ+nQ7//kNViUC
   4bEvnht8Hx6Q1urdgeXb4qb5FnDlY12b2e34s6PdUVePsJn5HIPFc8R/Watg4eLvzt1X219LDlXb
   xaPLNkawONMLJP8384aiBe+0LkVjoi3De4IX2Vg8o2SzGv9rM2zGiE0SCo34Db62JQVFsGKsAVBx
   avCspR2KGsFaIPg65ord5Jf5v5rg7tdMBP2Z/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sw+7rLeolz/OBNBOgh1u1sceFWmzxRJZviQxzYYI4RY=;
 b=bbS9bvD7+DLFhp2CMzc4P42tu2b32zWaWEzp/ELteOJZgUMdwVRC4tzLEe1HHHHimPsRux6Uymck
   JeKirRqIQ/pqrLACmt6Lb7jQzo52+WR/Qj1HmTHMSeG9CFx6jGI8lcBYOK1D7r/2Sp9lfRgN3e+U
   LVovo2BooeW+qsYc7vqLD7jKiErournt4eCHrTdYMH3b0TLpN2qBb1NRVks4d4zyEbOqC2BUI0aC
   7saPqV6CmwUBQ0dsS2LJaOXchRYzAh9g8bY3B9RwmM3BKd5IaXcC/0QVKw8ikwPJKhCGUjB5klUC
   u023nroWXGbYDNZJdNALlS/ywotiGGUbkyhYYA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQD009OCPX0AH60@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Feb 2023 12:41:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=qxjSHyo5E64imuTsFy/ezo2VUmPD8jzVtZLiGDzw3yU=;
 b=AhZvWQA7BhS2bXr5Noa+8wFfd+PZVUIwU3PcO9q3YEHMQCxvCE6TkWbwxpVUZyhECAuc
 Ai41HXKXvvKRx3UZaFqRI0I9RVPhetl4/v1/i/x5f5SU119jiKDuDiVWGHS6QyIdbXXf
 Jw24Z3AjAGvo1/WJ8beIPZQhQo1nWcGxx2ioSdKqQvaVpAbCdVBaN9a07JcMqguCNoHp
 m1FRjLhnp+eOmOPFj13ext6oqonMGxJ7vtZe4Q94NUadZ8ls8F5M/lv5lqGKvYwqt9Su
 tXMqI2ZaqTZlnjoc0xxlg5eiMlVD0EhRo0DZKZcsqtil2tS4K+TGekK7IWYE+MPic6CU Pw==
Message-id: <0e648efe4bc8028652a5d95ee4c3404bd4a91018.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Mon, 20 Feb 2023 07:40:36 -0500
In-reply-to: <70d079a7e8b2fa08683b68742a22ba2918765dfc.camel@huaweicloud.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
 <a20a6d84d8e682fbff546b80eda75a1918d7c108.camel@linux.ibm.com>
 <aaeee7490cfee1b2163a3c9c894294aaf13e100c.camel@linux.ibm.com>
 <95f9b1dfca0cbff1c6a447dde45c2f835bc1a254.camel@huaweicloud.com>
 <1e93d7b299de3b6cf61b5a5c4be91eb47d864ac6.camel@linux.ibm.com>
 <70d079a7e8b2fa08683b68742a22ba2918765dfc.camel@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-20_10,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200109
X-Source-IP: 148.163.156.1
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=173
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 priorityscore=228
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200115
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
X-ServerName: mx0a-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: OQCfUOfZOsvVSTr7PK2QOMNEGHdcvgjU
X-Proofpoint-GUID: OQCfUOfZOsvVSTr7PK2QOMNEGHdcvgjU
Reporting-Meta:
 AAHpGQ5pPaZ/ta42CXYKAi9k5ypn5zg8D0895fCn9cfBwBYG9qeheXUtBypjXcaY
 oPE0kOkIZ+IBP5+rW47y8o0Biops0eEwUoara3ubXo7cFahaDh1J5uTlAf7NQaIQ
 eEIICo7ifgP8ZPXkhSe7BaKbY1zFyMQM3BhurLtLHr7E1urm0+k2w9o4wRVH/oQ8
 +AqJkPWLrlkdzadNmFrFGmVdMOFt1afVbouOgQFo6aCJkYMe1MXayrrDLRom+Uop
 IlC6kjYjRTuiCQB7o47LAKUJ9bAJ+GVNgUvTsRq9dl/i6Dow+8EbpXg1us7nBGAu
 PLEOtueKct2vE1sXyRtvby2cIKzFVtRBrLsF89AbaqYW54+ms8/S7DHAiL7/fTlX
 RGPcBHHWJVEroQaQtKq7K6P1kM8CKDDjbQPyonoIjmw6I8xrtoIZgL6XrhFXq0Gl
 DQHq6io2yhwQQvtyjZws/dAdFSW4DiJTW1Wo0l/R3aZatvzWyg69v55NTsvwI6Vx
 H6zAdC7sqvE0Rqval95C6o7n7j/3vn0zyc5IJBD2JkJV

On Mon, 2023-02-20 at 13:20 +0100, Roberto Sassu wrote:
> On Mon, 2023-02-20 at 06:08 -0500, Mimi Zohar wrote:
> > > > > > diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> > > > > > index 95d0611c5fc7..55699c573541 100644
> > > > > > @@ -7277,13 +7289,23 @@ int ocfs2_init_security_get(struct inode *inode,
> > > > > >  			    const struct qstr *qstr,
> > > > > >  			    struct ocfs2_security_xattr_info *si)
> > > > > >  {
> > > > > > +	int ret;
> > > > > > +
> > > > > >  	/* check whether ocfs2 support feature xattr */
> > > > > >  	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
> > > > > >  		return -EOPNOTSUPP;
> > > > > > -	if (si)
> > > > > > -		return security_old_inode_init_security(inode, dir, qstr,
> > > > > > -							&si->name, &si->value,
> > > > > > -							&si->value_len);
> > > > > > +	if (si) {
> > > > > > +		ret = security_inode_init_security(inode, dir, qstr,
> > > > > > +						   &ocfs2_initxattrs, si);
> > > > > 
> > > > > The "if (unlikely(IS_PRIVATE(inode))"  test exists in both
> > > > > security_old_inode_init_security() and security_inode_init_security(),
> > > > > but return different values.  In the former case, it returns
> > > > > -EOPNOTSUPP.  In the latter case, it returns 0.  The question is
> > > > > whether or not we need to be concerned about private inodes on ocfs2.  
> > > > > If private inodes on ocfs2 are possible, then ocsf2_mknod() or
> > > > > ocfs2_symlink() would fail to create the inode or symlink.
> > > > 
> > > > Correction, previously when returning -EOPNOTSUPP for private inodes,
> > > > xattrs would not be wrriten.  By returning 0 without setting si->enable 
> > > > to 0, xattrs will be written.
> > > 
> > > Ok, but if there is a private inode, we would be setting si->enable to
> > > zero. Should be ok, I guess.
> > 
> > si->enable is being set to zero, below, but is conditional on !si-
> > > name.
> > 
> > This is the last concern, otherwise the patch set looks good.
> 
> Uhm, if the inode is private, security_inode_init_security() will
> immediately return. So, the condition !si->name should be always true.

Ok, thanks for checking.

> 
> > > > > > +		/*
> > > > > > +		 * security_inode_init_security() does not return -EOPNOTSUPP,
> > > > > > +		 * we have to check the xattr ourselves.
> > > > > > +		 */
> > > > > > +		if (!ret && !si->name)
> > > > > > +			si->enable = 0;
> > > > > > +
> > > > > > +		return ret;
> > > > > > +	}
> > > > > >  
> > > > > >  	return security_inode_init_security(inode, dir, qstr,
> > > > > >  					    &ocfs2_initxattrs, NULL);
> 



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
