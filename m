Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD15C636CC
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Feb 2023 12:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=65fKUxzm/jHSVYJnKvdOs4kVbvss9US+/ilp2rgYCjU=;
 b=doicT1UMakZgltoUFxLS+ripLppIV5d+fOY+o+qMbfp5t/Tww6gA93yQaD/nfSnWBjXzTxuoxcpJ
   Yp7C/JbIS6ntq2yIhz/dPv94yK0mXT48yucsTaYPMupZZ0HYCrrpKc/jLBQhjbxIv2BHRzD1OxoM
   dgzzpZ4AxAfUO6hPGzDou7223gEqOca8kKx16nthelxKaDy5y7Yd76vkBuWkWt0wkzcSNI6cCpU2
   294xWn04dYU7p9t49yLrzLF5eaJOLYMSe8R8JDniq2aNLTEXkBsHFm4YmJ6rEOJYdgaPFTOSGGkG
   q0wMd4WmbKh/KULcjtveqIrwO3g3RwFSj+eY3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=65fKUxzm/jHSVYJnKvdOs4kVbvss9US+/ilp2rgYCjU=;
 b=rKcU8vbzTJ+R4u1ZpRFFQ4FXPnMr22V+fWbLdKkVfGxo6HGAP1hjocVfJLOmrBBTaMCOUQ8WRD4d
   7Ex2cxv1g39DqlTYZ0SEIdubNR00o3hG3ev1mGQQZYy/B1fmEAyo7rhYWY7eRs60Lju8LqGHahuj
   chxCpg/mkmhf3QutYwkvR4Aw/ar3NQItcx0xf1nj2FgGDgyrEdcUrAghNsdmW1+iMnbhswRI53UO
   2CLjaDFlug9sLme/uzVTWSsb1HHp0FMoSErKORwrehDYjGyW6dx8dKygO8JvJegNwFREbLnzqgHb
   1isdgBOadAUNjR+Tr1GOFar7ufvFXDIR1LR19g==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQD004GHP0R65D0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 20 Feb 2023 12:22:03 +0000 (GMT)
Message-id: <70d079a7e8b2fa08683b68742a22ba2918765dfc.camel@huaweicloud.com>
To: Mimi Zohar <zohar@linux.ibm.com>, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Mon, 20 Feb 2023 13:20:56 +0100
In-reply-to: <1e93d7b299de3b6cf61b5a5c4be91eb47d864ac6.camel@linux.ibm.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
 <a20a6d84d8e682fbff546b80eda75a1918d7c108.camel@linux.ibm.com>
 <aaeee7490cfee1b2163a3c9c894294aaf13e100c.camel@linux.ibm.com>
 <95f9b1dfca0cbff1c6a447dde45c2f835bc1a254.camel@huaweicloud.com>
 <1e93d7b299de3b6cf61b5a5c4be91eb47d864ac6.camel@linux.ibm.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.23
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=138
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 priorityscore=48
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302200112
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
From: Roberto Sassu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Roberto Sassu <roberto.sassu@huaweicloud.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-CM-TRANSID: LxC2BwCHCgavZfNjaQo6AQ--.54254S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw1ruw1rZryrAr4DAr43ZFb_yoW8tr43pF
 W8tFyUKr15tFy5Cry0qa1Y9ws29FWfGrsrXwsxJr1DAF1qyrn7tr1Fyr1Uu3WrJr98JF10
 qr4UAF43uwn8ArJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI
 7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
 Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY
 6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
 AIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
 6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAOBF1jj4maCAAAsh
X-CFilter-Loop: Reflected
X-ServerName: frasgout11.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: sRgK1phmjUV8woKjG965DEZM8IdZIsWa
X-Proofpoint-GUID: sRgK1phmjUV8woKjG965DEZM8IdZIsWa
Reporting-Meta:
 AAERJdz4f+y0cvTxqSWAunTKp72ioZjyOHL+RUvUlafNxpFgDTBpRGWHOIAhQQKA
 TNbNbOMsBRgyXGs9Z86zhFVy0x9bbH5bZvfX6T2bB3B9/OXZqbTa9eNZLHJ5OFuf
 3Fszs5afUZKlaULlH50p/7WpSia+mZ0Ymp7MGLfXmi3LGjgNy8fdePESbAxVGv+N
 ReXPCvh7SGr8DsfQA2Hz8WzVm4wwqj26JHEdqIgm5vaJRit+yObAPe9fapb0ZovH
 bqdZ67ERT1faIWUNy1cN14PRg6aeNlTF0ASQiiexeP3pEnKzoyRIyaOQdlWFdkHt
 hRpeP6wZ7AKJhOhZgd5Bt/51nEtv5DXW9Ly26aE6ODVSeS39EHNwIJ2sav6/3KVg
 04pva+fLOnGlYxKXPLqaG5nbUu7Ayn+weVApOiR/YqJivPzXGa4Syfljy+jrAzDu
 1KA5rEdxU1zcYwDtAlMh4b2fSkTE7uLblNs987qfF5QmRK2JF/a6CsF4rGLEJDTX
 Zp16WUhHb+DfkRLsiTlR8v4dd1yVTpFRiTjKYBkDZQU=

On Mon, 2023-02-20 at 06:08 -0500, Mimi Zohar wrote:
> > > > > diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> > > > > index 95d0611c5fc7..55699c573541 100644
> > > > > @@ -7277,13 +7289,23 @@ int ocfs2_init_security_get(struct inode *inode,
> > > > >  			    const struct qstr *qstr,
> > > > >  			    struct ocfs2_security_xattr_info *si)
> > > > >  {
> > > > > +	int ret;
> > > > > +
> > > > >  	/* check whether ocfs2 support feature xattr */
> > > > >  	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
> > > > >  		return -EOPNOTSUPP;
> > > > > -	if (si)
> > > > > -		return security_old_inode_init_security(inode, dir, qstr,
> > > > > -							&si->name, &si->value,
> > > > > -							&si->value_len);
> > > > > +	if (si) {
> > > > > +		ret = security_inode_init_security(inode, dir, qstr,
> > > > > +						   &ocfs2_initxattrs, si);
> > > > 
> > > > The "if (unlikely(IS_PRIVATE(inode))"  test exists in both
> > > > security_old_inode_init_security() and security_inode_init_security(),
> > > > but return different values.  In the former case, it returns
> > > > -EOPNOTSUPP.  In the latter case, it returns 0.  The question is
> > > > whether or not we need to be concerned about private inodes on ocfs2.  
> > > > If private inodes on ocfs2 are possible, then ocsf2_mknod() or
> > > > ocfs2_symlink() would fail to create the inode or symlink.
> > > 
> > > Correction, previously when returning -EOPNOTSUPP for private inodes,
> > > xattrs would not be wrriten.  By returning 0 without setting si->enable 
> > > to 0, xattrs will be written.
> > 
> > Ok, but if there is a private inode, we would be setting si->enable to
> > zero. Should be ok, I guess.
> 
> si->enable is being set to zero, below, but is conditional on !si-
> > name.
> 
> This is the last concern, otherwise the patch set looks good.

Uhm, if the inode is private, security_inode_init_security() will
immediately return. So, the condition !si->name should be always true.

Thanks

Roberto

> > > > > +		/*
> > > > > +		 * security_inode_init_security() does not return -EOPNOTSUPP,
> > > > > +		 * we have to check the xattr ourselves.
> > > > > +		 */
> > > > > +		if (!ret && !si->name)
> > > > > +			si->enable = 0;
> > > > > +
> > > > > +		return ret;
> > > > > +	}
> > > > >  
> > > > >  	return security_inode_init_security(inode, dir, qstr,
> > > > >  					    &ocfs2_initxattrs, NULL);


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
