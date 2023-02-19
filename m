Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A12C636CC
	for <ocfs2-devel@archiver.kernel.org>; Sun, 19 Feb 2023 19:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cYv+pOUTGD+zZ+Hrex8TF6GwuvtH28a18HdNjTHcAjU=;
 b=zB6ZIMdlSmS0ZvazJws3cv3pWLNL8Iu6ZhF/tRwXzLcSzsB1O5Dq6emSgo4Ke2j+pQcpyAiG6FB2
   XqGj36JmTqYN1CR9N5zCBliOHD7GAUaPTNbcZ3u+cFbhduy5oDCXYu/hev+v2QnAG3sHheMgCQzQ
   76vTHSTW7NyOQA6qo4QcG3oETFF6Z9pWeJhc8NFEmLEuTKksPNRvKqlpr6Vs2yv7LdgYuz9MlR1u
   dc68ALh82g3uM47LB/vUoUfuygIOE6mhYygjS8QVj6dXJLpSliPR38Tfk2zrZR7GOHwqqo5YCoPb
   y+8mkLaxZI11HGHdnA+OgX2K84Tr59URnmZp/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cYv+pOUTGD+zZ+Hrex8TF6GwuvtH28a18HdNjTHcAjU=;
 b=rTmLKmo2R45pmZGmvnUG6lY+erJHLwgyCJ2rDVYZsq8LAiKXKN0jqJO6dmbD9HL+uawa1gqGW8+y
   tLJCC49aSKbCOeycWPDOMSNHLLLdn+bg4Kog5N16Ee892QJR9MtCIrXlNXwU7NkvJWktBZTRt0oY
   /TwRDQIKQgAb1xzU31M+93UJp6J4deZ8992e3rJ0GSy0xQakSMa+cNtfIj9dbvR8gHHTd2fUoYRn
   GK28EdG7WMguesHV1thixUV+9Ctc2TX8oAPxvGZbmTlz/TdUFrHVSybDNO5uKC80yfFXPItxvSME
   ZKNODhlkeWGVEgA2SUUV788Ngf0YEQxS99kjVg==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQC00C9JERM0GA0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 19 Feb 2023 19:42:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=1Lm6G//TtEY+92KWMgEexavCALyHAPzjuFrffbAZvAo=;
 b=jRO5tCNxrXC6dRGkv7AKMoRb7AYwy5I3BUuXgMk1tCHYsz/uUv6U3vKMhm9H0VdMeiOX
 wKufqenv5jErM4jkneDshjJJicXKt8LchVrUjjZu+CvGn2KfGiIF0FlYjVb4NUw6euu7
 4ceffMFznYetxdMZVK0gqZjFCa8JcGJZc1Bj4P6ElsgEutZnoep/XdI4q3V6TIhl+YbH
 4Z4b1+PKkw8JGjzA+qGppRpJWLl4iazqVhQi/xtaSBHocW1lvCdiOFormh2Sok7uCn6X
 jZrN7tiXk2Qj+5xdAgASE3p6UtuaLD593YpawValwWO0+6s8898TBriLiW07uaUCCCiP GQ==
Message-id: <6b695665f9188087fce6e693d46a7d4088ffebd4.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Sun, 19 Feb 2023 14:41:51 -0500
In-reply-to: <20221201104125.919483-4-roberto.sassu@huaweicloud.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-4-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-19_12,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302190186
X-Source-IP: 148.163.158.5
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 clxscore=157 lowpriorityscore=0 spamscore=0 priorityscore=172 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302190188
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 3/6] security: Remove
 security_old_inode_init_security()
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
X-Proofpoint-GUID: wm29mEG-RiLoZsEkObOtCf8WN5sBgWuH
X-Proofpoint-ORIG-GUID: wm29mEG-RiLoZsEkObOtCf8WN5sBgWuH
Reporting-Meta:
 AAE6bGVbVVFB6qLcBF7DAuFV9tWzq/JdHpqKGvr62VuCpCX/m//L2IdUWMapIQbb
 7MtFUxd4m73OtQDLUu7gi8uu6xVR4FV2bIJh1cQfva1veAa4u6zwHlF4mJaTy3P6
 2VKhGwimdEa8bmaXYqhWVc7egLp86808ldWdj8HDGgWuSO/NUTs/iu9YSOHRWa4B
 9IgrBRvpaxCccXRGqZ1w2qSDiesELkX1aaweCTWTg95sl0d7S4kDGEDKXSQJSpw+
 O+Z6UGjS1YefT4TvSD3llx2qfxRGalxApSwa725w/fg2YlIwZx1vVvMuDKNAN8sw
 vdl2ms7+to/BL2+17MnecmShqLU/udRqcddkapwk5fihU6chEbyIr/w0tnPkbqpu
 MGcHNKj/jrqlPNP+f/aVbVIqatJ9gnJve+xq3eSOeUrGiCZEd8WBde1KzunPDzib
 i7rNws1qTxqgslPUiNKJVZWwzpUTA7rVa+AB96BSg867UKDK7xvEWv+OAKZRK/Fl
 rgbAQELu2kv0cFZ1wawf5gr+MYv5k6mXPiyTYJdx3Nk=

On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> As the remaining two users reiserfs and ocfs2 switched to
> security_inode_init_security(), security_old_inode_init_security() can be
> now removed.
> 
> Out-of-tree kernel modules should switch to security_inode_init_security()
> too.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

Once the ocfs2 (2/6) concerns are addressed,
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
