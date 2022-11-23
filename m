Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF5CC4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vjrAT0vstQpfqqCOTepKGbSxWGPAY31F2MArDjYdEgc=;
 b=BZdXa1+0VVhBxsj3DXaF8aBdHI+lSJ9Ib8hr0XqIAgRqJBK1m1usCbF/7MWzobZsMudfWG7CMtBW
   STHezYH/aA8Q4lmd/vIIhrJj9inBQCgulsnJK/SiS8B5x2wzGdzJSypXzLkB8JsDWFsHDvG1gwkA
   YA8hMcFg092NWdpsJ66Itpaq6jQKFGIsMZjyFOK74PuPYcGWWmZr+FbZBjQPvDwehdtdseTLe6Uj
   BQ0iPSUBPjiFSR4BVMT+4UdsVfljMYnEBiBxz/YyBKpRvUGtIyW8GWMaKpllzCpk2ENPzvIs+sUP
   EAcef24wXDjfH9KyjgpkZKAkmQi/7Mfj3cWVHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vjrAT0vstQpfqqCOTepKGbSxWGPAY31F2MArDjYdEgc=;
 b=oTQevY9dZPMvGf+pzBTjeyJq4n5Je56CoD4D+sOhVD4Me55++aGDiWsmlrh/VW4000q5318CljSt
   qNmj8YfFd94OttXkqwiIF5wnLDXSgitKNGboDHpYLKyZRYbNBE6j3F9sRG7U0vgjPGbclfTGdR+l
   AyG6+yo9K4pwb01vY6rEqVG5JHR/LvXjM++bb6ZmtFKwgqsN6Q3bGrL/xds3laMi/NT+c2WGewJh
   y+LRIe3BcqWBG/GaMuTIS8G8ZJaU1hDk/ohKFOhg1ZECMA2qiQKk1coJPq3oegMeGSqWXsPdQN/d
   TKeTHWcdfD4AC45aQ9mMhOa6KMWj1G9qh5n2dQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLT008K36VJLF40@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 16:23:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=DGIE0IcQ/4Ob6lIB9Xu6gY2wRn88lzgW3JmHywvHzKA=;
 b=hKMi4em2yrex+9WFg6mkd4/u+MFEF25CWOax2DqMDNRabnG05st9JP2dlFR3UQPWS0iJ
 cReqe+AjYto7WBrqkhmsnD/iZOZTbxt3VRmWY574QVbpn0LInmZRjnfpfjZGInoUWQ/2
 uUmqcCwJI+y922b2xrmjR+cngRdBbqO6HLHFQdkF9h/WK93zqUaKst0LmWJrelPgAna3
 mH7jZzjJ5VUrPR4g9yKvD6VmrkBeX/vAMlKV96nA1AaPAds/elFZePuoX/RhqIlqzt41
 BbV9+w0pmwlxHepYFue1BcrWcFEN4vFxnH0LGlsk7kVI5VZ2Oo7+HM2dC3mReTa/A870 bQ==
Message-id: <33329a29d779096e043f53c681f26ef32b093e5c.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 11:22:59 -0500
In-reply-to: <20221123154712.752074-1-roberto.sassu@huaweicloud.com>
References: <20221123154712.752074-1-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_09,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230119
X-Source-IP: 148.163.156.1
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10540
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxlogscore=950 suspectscore=0
 spamscore=0 clxscore=117 mlxscore=0 lowpriorityscore=0 priorityscore=248
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230120 domainage_hfrom=13398
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v6 0/6] evm: Do HMAC of multiple per LSM
 xattrs for new inodes
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
X-Proofpoint-GUID: SBCz-VBNNtbAW6hZNWYcLh0I5YGGEiI3
X-Proofpoint-ORIG-GUID: SBCz-VBNNtbAW6hZNWYcLh0I5YGGEiI3
Reporting-Meta:
 AAHPnZfoIB0iKJoKXHjGRLadoqW5vIeiSpkzDtN3+Nmk0SPgoDfcaX3QDhijH+hU
 MInCw4l9Lg4om7vtykfCLMFzoROLaUIGZ7980KGHjOB50wk9NCuNy0a85ceh8Q44
 jxWfjFH0aXHUQ9wfJ/HMJ3FmiBYSMzYoUdcfslqR6tMX5tgv1jzb6/npnJrzaeGp
 CnMP83ef182McvdSXofGxjWZOAeEZT16RwR5chuLw5atSMWaWohueePelCV0iPT0
 B7pOGZ1cwXJxVRRS1mqMGT463FL12oUObgSM0m/YjctcYvwKQ6TU1x/4lCPQhIkf
 FbvqZkGSnTmzKzS2IKQZhxT5ECfS19dpW3df9b0p/2r0t7fdVDySmEZsv23xPAKs
 g7q9T3wDJD8kGoljYWLb5pQB+75Zd6dTuJ6ngN00Cy7JoaNGu8L7XdhdO55dB5Kc
 bQGDLtmKPZdd0dkfYvTl9iYa+jAM404vrtbdTdS6U+0W/h3ORHvJXOz1syShT9o4
 F1XnPFAnhV+LMXajZ/H9+Jc++kcDHJdnHRk+O08d6fk=

Hi Roberto,

On Wed, 2022-11-23 at 16:47 +0100, Roberto Sassu wrote:
> The second problem this patch set addresses is the limitation of the
> call_int_hook() of stopping the loop when the return value from a hook
> implementation is not zero. Unfortunately, for the inode_init_security hook
> it is a legitimate case to return -EOPNOTSUPP, but this would not
> necessarily mean that there is an error to report to the LSM infrastructure
> but just that an LSM does not will to set an xattr. Other LSMs should be
> still consulted as well.

This is just a heads up.  In reviewing the ocfs2 v5 patch, I realized
the meaning of -EOPNOTSUPP is being overloaded to mean multiple things.
Originally, -EOPNOTSUPP meant that the file system didn't implement
xattr support.  Now, it is being used to also mean no LSM xattr.  In
the former case, none of the LSM xattrs would be written.  In the
latter case, some of them will be written.

I'm not convinced that overloading the -EOPNOTSUPP is a good idea.  
Still reviewing the patch set...

-- 
thanks,

Mimi


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
