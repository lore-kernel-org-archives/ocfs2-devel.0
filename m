Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 366F0C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Dec 2021 23:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bz4fqZ5hk8LGl7HkdX5sdasHUIU1wqYCOMAH2jwkplk=;
 b=1R6AVPoO9RF63agWRkQU/8E/khpd82s4FYnBerp8P7UHOmNTY52yHumb8pmd+THtuxQfV7dpj3Tp
   voeHbYwbmg4OJIT6y+KLsNi7xc3P1BfCh7yVb9x1WwqcQpWDT5UWHmK/sXGO595WWc8jrzQat8cZ
   fbuqOtT1K5/MvbbZxHNS0tDY5w+zrj9TKEfsqnTseZIU90ICVIEQFGiIgucvC4DS/FpvCSzcLE2m
   6DLbF6bl0xIodf8roXfRbUI3hpsluBhpp0jT31ZYKKUQ7g3dhWncQmxS6WyebclryUsIRpyWOeXD
   TbucfEqv6NST+8Xl7s9xnuuSZYVNEDLpzkNR+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bz4fqZ5hk8LGl7HkdX5sdasHUIU1wqYCOMAH2jwkplk=;
 b=gLdl4hSLEtratsXTkCmAiHr0tyO2J6ittSSW7fbXTO1ATEAeG9QddfPqx1Bl0NS8h2NJ5qxBeY/Q
   3rk20j+gAUkb5Seh9zi8dulNu3SStN75ktJqKWpbGzQgS0IYJF9YmLf//ep61tbVNjTmANjgyAQI
   XY4IXDcuYuBQmR6/AAaTyfjaVgrE48z94i2BlujbhXfE+tfPv55V9j13nHtKyw1+lj7GhffICe4S
   XFPqKcy8iEONXPAeyCuOriEp3gVgFhUEmlH5KcOB7lvjvSRR5Cucm5x+j2V6FRSe2KWSs3taK8GX
   OmpNGDg9No/+RyOYAYewOAZFrWUtr+/qRo5ZCA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R4W004T8HK2K5D0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 29 Dec 2021 23:36:02 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=akpm@linux-foundation.org; dkim=pass
 header.d=linux-foundation.org header.s=korg; dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1640820949; bh=8g+OuQBldqaoo6TyABRspjHyWqFG9bqmmGvgEzbBeis=;
 h=Date:From:To:Subject:From;
 b=VBAbPmhvULkazN1ceL7/4Phw7ZWRqhONClOV6n0tL8ePOK1pyUCNUC52zgaGShUjn
 PykFwM84s2sj8eOUoxq+fdpgakdmsmrR83QVfv/5HSDv3NUZAUka1axNlMKedt4kIi
 VQpcCKhtsjx+O/OIhDw0d1LmP/JOyc6Uju3GnANc=
Date: Wed, 29 Dec 2021 15:35:49 -0800
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
 junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
 gregkh@linuxfoundation.org, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com
Message-id: <20211229233549.asRi_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10212
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=280 impostorscore=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 clxscore=243 suspectscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112290125
Subject: [Ocfs2-devel] + ocfs2-use-default_groups-in-kobj_type.patch added to
 -mm tree
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
From: akpm--- via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: akpm@linux-foundation.org
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: C5iAfwrAyr3Tnzjb79A-ihd4zxe_Q-UT
X-Proofpoint-ORIG-GUID: C5iAfwrAyr3Tnzjb79A-ihd4zxe_Q-UT
Reporting-Meta:
 AAFA26c9/QcB5z4aDgJ6mtntS4gcDoW5OYjhNTd6RRC1tglYqs6lMWtNWviLov7n
 FALdJoi/soUSX14pL571tRLinbkvqLy/2KLAyvo8FDlVJ54ZXclfO+kyAdCQ6u3Y
 arCgkuB4svV6oWPcxlGuww2ePgc9vEybLEXisDdKPqdTlpoDAhOIfAUyjpW841ed
 CnEF9bsy9BPKGaKk1hml8RJAGjHgmeCVtn6U7zxLDzgaKI9zn1W6ToU33vU8oi3a
 ZX3W4O32WKAPBJVb6V2C7qmjC1+B/c4tcTMQ652BkD2lNgPyhWq/dfVCLiEm6yOv
 yuyqio7K7UaOG/pM6I4e4k1lA2iRsgKs+tqrqxcPwBzbLU0wUpk+Lj1bjXPYLFCU
 2iFKOxbiMm6YjnSeAivBFtBM64x6MrH6NgD4yjlBeTT/qpN5j5OUE23uB56HHJNE
 LDS6MzDhk6nZ9q0Yf7DaQq3vt2AvTbRGoV6jwkdlS6YJIHVIYrnc4rI9r29MHD7/
 ehIGa/P3VensUgRBqYfO974SsyGe06QJ7Vepz1L0uIzI


The patch titled
     Subject: ocfs2: use default_groups in kobj_type
has been added to the -mm tree.  Its filename is
     ocfs2-use-default_groups-in-kobj_type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-default_groups-in-kobj_type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-default_groups-in-kobj_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Kroah-Hartman via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: use default_groups in kobj_type

There are currently 2 ways to create a set of sysfs files for a kobj_type,
through the default_attrs field, and the default_groups field.  Move the
ocfs2 code to use default_groups field which has been the preferred way
since aa30f47cf666 ("kobject: Add support for default attribute groups to
kobj_type") so that we can soon get rid of the obsolete default_attrs
field.

Link: https://lkml.kernel.org/r/20211228144517.391660-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/filecheck.c~ocfs2-use-default_groups-in-kobj_type
+++ a/fs/ocfs2/filecheck.c
@@ -94,6 +94,7 @@ static struct attribute *ocfs2_filecheck
 	&ocfs2_filecheck_attr_set.attr,
 	NULL
 };
+ATTRIBUTE_GROUPS(ocfs2_filecheck);
 
 static void ocfs2_filecheck_release(struct kobject *kobj)
 {
@@ -138,7 +139,7 @@ static const struct sysfs_ops ocfs2_file
 };
 
 static struct kobj_type ocfs2_ktype_filecheck = {
-	.default_attrs = ocfs2_filecheck_attrs,
+	.default_groups = ocfs2_filecheck_groups,
 	.sysfs_ops = &ocfs2_filecheck_ops,
 	.release = ocfs2_filecheck_release,
 };
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-use-default_groups-in-kobj_type.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
