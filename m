Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC485C6FD1D
	for <ocfs2-devel@archiver.kernel.org>; Fri, 17 Mar 2023 19:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qmo5OGfyUL3xAMbktliaIODHr9pAbPGVQRuVI3/gmIc=;
 b=HwNxdXfE0jYn4XavTEs0SYFVFHnvSt3ZjMIcRA5BVhtp4njmWsIiWgQgCLeTfoHFALwSqK4qsJBY
   nw80MTgzYwKAmQQawMwHisrHkXSiNFXVoukEzkzp4p0GtxUb1ebzZMtNWAgYXBS44itgdtBJqM4e
   iRAK4UyTTDK29AKpaUjPPhuBN+c3ef/TgJyiEBHdXWhHfBBlSXXUXfVI/k4ea1qkYTh9qTmu0tQQ
   musQmQMuU4hdjbTCNBWQvUylFZHVq+k8vsY0Oi2KDasK/jRvzNh5HWpO+7p7hGfdgFujNPI55RCy
   Pq1Da2qbrru87M9cxBs0HB/irN4tzKZNx+6HFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qmo5OGfyUL3xAMbktliaIODHr9pAbPGVQRuVI3/gmIc=;
 b=HqVdttdAmo+y+7Z0KAHDc5OYUsJRmg8Gh03tlX298PW21BaAWQlipcpMHBXqgwtBg9kXHPnINcG5
   4YzkpX9kS1Jh3eblpJCnQtcIpXJJQuSvqE5+C8ej2NUNlWp7J61thZDLZHPnsM2x75uNa98wy8PA
   Mxyi61Kg1KiX0WldBvS8Y//vgzfYE7smMQraXvHwMQDvtYaIdOtn82McDnWjqEaFCngMSPRxipsp
   z8utO9dZZWMqxmlJCEfRiVOfLuZYqXqLWyHaWMcMF6nSzZznW2QQj9Y9/qgSMqDKkC2yQtwLH0C4
   KKP0K3dgfaBAs46/kcu+X7yfa9fJTQDVr46Lpw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRO00AFYJYPNMB0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 17 Mar 2023 19:40:01 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=1URlbCasJqipj7wwAu3MyeP8tjG8naLb0x+gto5CH0E=;
 b=Pefo3U+lud4skk509kTTR+mhHmLTPOJvxx+Wv6DaLae1M24kbAhsa3/5WNzpvDFNkbrq
 wiTxibGXwGRpT7XkXvj7mqYp86h6z1EWERlGT+dsZ45G+Rpc0t7enir2XbcXiwM0lrnw
 gYIfhFhlnPdI8bkJjbLWBs8hjB9+kCRZpNqFy1aKAl606W/vQG4Trh27QqCOeGVYd53H
 zy87NURsiYjOLinVrdr6qBIa75cXbHVtDFBjnis+eEa59OzXZo3PGXfqAYHU//LnYDFF
 KsFQzFrvugKuh4SHXPhJqeNtBKnXHNK8xxFAxu3Pn4ojwpJV/c3MGS/2L9pKXofrcKiP HA==
Message-id: <31fc7724c9689e8ec5bd6bfe026652d238d9fb84.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Fri, 17 Mar 2023 15:39:05 -0400
In-reply-to: <20230314081720.4158676-3-roberto.sassu@huaweicloud.com>
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
 <20230314081720.4158676-3-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_17,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 suspectscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170136
X-Source-IP: 148.163.156.1
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10652
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0
 clxscore=94 phishscore=0 mlxscore=0 priorityscore=251 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303170137 domainage_hfrom=13512
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 2/6] ocfs2: Switch to
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
X-Proofpoint-GUID: 4E5ttnrdrtplapJt8DiSan5ZGlK3fBuK
X-Proofpoint-ORIG-GUID: 4E5ttnrdrtplapJt8DiSan5ZGlK3fBuK
Reporting-Meta:
 AAE9Z9bjgOSBk+Av+V26J9IU5cgRB413z09TeU9SFMfGUMxH6aLaQr8tEwFs72Pl
 blKZHgi2OGQPueeL4Q2+N9bsFhlocZOJc8alsX4AUrcuWedcAbo9XtXROjDbcbp8
 DiCWCcZN786HK3N0g3H6RHaNEz/Lz1SYbLplJAj6Qx30YpzYg38OCBEuhkJ1DSTv
 BwWeZbhpNRw/fvwuY2qLr2/BMyalHnZmeZ6wkNb6Lhl9824jTSdqJnBcHyCgolCr
 9sR59wh8abGgB/k9Y5UJPet7jeRcvydngbLYLOu91PAb0TAf9nQk6JLV5FO/2d9o
 ds/GDpM7j06IMTnfYr5yxoFiawyK2BO926VCvkJERaImgxxACOLme6HKTQh3q6+r
 KcQd2Ib7n6UqVBOXxH14Nm+RJ5xCUwxlmKcXvS2uS7i4CmL2DQ15JXgWcssdf0Xp
 gDvmjxPCtz9RFrOstykHtX1d3Bpr6h8101izKJyoNKIlFNJneG5OCEVUwxaPN4dg
 wtSTZc7ste/zN3wWWQRGyyN0d8Rc7uvtkV+/cr7KulykHQ==

On Tue, 2023-03-14 at 09:17 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> In preparation for removing security_old_inode_init_security(), switch to
> security_inode_init_security().
> 
> Extend the existing ocfs2_initxattrs() to take the
> ocfs2_security_xattr_info structure from fs_info, and populate the
> name/value/len triple with the first xattr provided by LSMs.
> 
> As fs_info was not used before, ocfs2_initxattrs() can now handle the case
> of replicating the behavior of security_old_inode_init_security(), i.e.
> just obtaining the xattr, in addition to setting all xattrs provided by
> LSMs.
> 
> Supporting multiple xattrs is not currently supported where
> security_old_inode_init_security() was called (mknod, symlink), as it
> requires non-trivial changes that can be done at a later time. Like for
> reiserfs, even if EVM is invoked, it will not provide an xattr (if it is
> not the first to set it, its xattr will be discarded; if it is the first,
> it does not have xattrs to calculate the HMAC on).
> 
> Finally, since security_inode_init_security(), unlike
> security_old_inode_init_security(), returns zero instead of -EOPNOTSUPP if
> no xattrs were provided by LSMs or if inodes are private, additionally
> check in ocfs2_init_security_get() if the xattr name is set.
> 
> If not, act as if security_old_inode_init_security() returned -EOPNOTSUPP,
> and set si->enable to zero to notify to the functions following
> ocfs2_init_security_get() that no xattrs are available.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
> Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
