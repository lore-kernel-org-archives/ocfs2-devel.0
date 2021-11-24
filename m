Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A13C43219
	for <ocfs2-devel@archiver.kernel.org>; Wed, 24 Nov 2021 13:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yUvU8VeeyDlZlo46YVYPILLUJxt6ApTRMwPC9o2ZK/g=;
 b=0wC+UyfEXiX6u+nvs/kv0oIx/DsNAiUXRvwhDDWKkxWQgUQPBNYGkGHK9jHjKjSWnwzCBWxLgowM
   aSQZRw0qrgQZUozzRBiJ/ch7Pw0iRfIEmbF2NaIymkGqRuOw/0hgCRTXBQj49RwWLbYBiQjPpzJ0
   bZsdz3nmFVDtY/m8vqIv71ZYFbjPoaTAUuJhvKL99jHePdf7u6G2o/9hl3INpEACdRsTdqkB/MG6
   yvKRwTR7GNZvD70GiYudK7UoKrujZsfcu1adyUUPv0bHUcUEgIZxcS1zHyYJp+p02IMoQRI7Ei6J
   YGdhtR6zKJGBdBYUD3/reZYriQI3dZUJOdQbug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yUvU8VeeyDlZlo46YVYPILLUJxt6ApTRMwPC9o2ZK/g=;
 b=qFctq/LMErCbYWatwe1AhwWE1GskxC3ndXS5FGszwmf6EvgSBTfrdGNikwGw61P+lTGnBBrndV38
   Z5jk+yoGEo2VvyKwf9odw7LYeyJgDtsvWyjoL3ZwiOL/6FrPX+4yGk7970qPzAiiucGMC4OM9MpE
   LnvYjymhBg8EbQfcWIsbT2p2bKaKiiAEYOunQrwrICPCOATUsXX3ymZGWVcaiQ4/DAheWK1lji0l
   gLNrVtOIO/ySc/KwhkpIeXyPNT0jgrZEpLyqT+QodVsuTOF11tVSoODve3ueMsA3XXY3lXUAlprs
   uKdHM9sj+j8nr4GbSDtDj9xnKLEJTajiPYSMPA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211026 64bit (built Oct 26
 2021))
 with ESMTP id <0R3200L7GWPWOA90@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 24 Nov 2021 13:41:56 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=none
 smtp.mailfrom=mcgrof@infradead.org; dkim=pass header.d=infradead.org
 header.s=bombadil.20210309; dmarc=none header.from=kernel.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=u5Bp6Rfma9GvNlchoY1NvLTwJANeJ3HEug26+8isXwE=; b=hhbQZhJwK1Tb9e+q0Q28e25DAv
 Od9pIYN2Gyiv0dA95pkKXYVes6wIzr6Dyrdz7zE6LWYwQgtKQRddQQj3KlF/6e+rGlvDwZn81SO0L
 jmyNcKHUwuAAL4hqFxxBoCLbZ78/8YU9GtUBk2390mHdprFJB6Q5NEsOuCM+WqTROXedt17OSU57K
 Znwqwh32TO/nbgJf5ps0iEH4WpPxtncH2AfxYxaIDPl/mI7K7oszTaCg2ZYrE3yeotZ03DTuOQM8q
 SbFyM9HClWrBqJvP/vIs76mbieTIOeBHp8+RY1gteGkIKaIRwSzmIllOlYTn9YYs66Or0n5wDgTmB
 pHDv3JGg==;
Date: Wed, 24 Nov 2021 05:40:58 -0800
To: Jan Kara <jack@suse.cz>
Message-id: <YZ5A6iWLb0h3N3RC@bombadil.infradead.org>
References: <20211123202422.819032-1-mcgrof@kernel.org>
 <20211123202422.819032-7-mcgrof@kernel.org>
 <20211124094409.GF8583@quack2.suse.cz>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20211124094409.GF8583@quack2.suse.cz>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10177
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=140 mlxscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 suspectscore=0 clxscore=188 impostorscore=0
 mlxlogscore=962 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111240077 domainage_hfrom=9028
Cc: airlied@linux.ie, benh@kernel.crashing.org, amir73il@gmail.com,
 clemens@ladisch.de, dri-devel@lists.freedesktop.org, phil@philpotter.co.uk,
 yzaikin@google.com, joonas.lahtinen@linux.intel.com, keescook@chromium.org,
 arnd@arndb.de, intel-gfx@lists.freedesktop.org, jani.nikula@linux.intel.com,
 viro@zeniv.linux.org.uk, rodrigo.vivi@intel.com, nixiaoming@huawei.com,
 tvrtko.ursulin@linux.intel.com, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, julia.lawall@inria.fr, ebiederm@xmission.com,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 6/8] inotify: simplify subdirectory
 registration with register_sysctl()
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
From: Luis Chamberlain via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Luis Chamberlain <mcgrof@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: sFJIvQtVAb__edtUYTElAuZd0xfwRlkv
X-Proofpoint-GUID: sFJIvQtVAb__edtUYTElAuZd0xfwRlkv
Reporting-Meta:
 AAFINjaAFoqUa44f+q8Pmo48t7zD+lgrEQNt79blXNIL1e8w0QlAsMS7WYW0lYLS
 E1x4AJ/tRDqZL05bWR0JRhJJvLNPQsPRWPh1QiTx+cHig1NiMaD5NZt1FT88NAj5
 qr56v9cMXBOuN1K/0+8yna6lWOqoo2iluQ3mON7hR1dzmrwdh7MeP5uS3MYh0VcO
 Eje5ND1xHGEnc5tXZJFeVbb7uL2o+Ojy8EExsfDoRleLEvmEhcDmzJSiQo/ukTrw
 4r266j5D0FKb8TWrawhX8GP9lhfcvEvtJpebR8j1DqFE0gSfNYKoLi93oVH56xKj
 ouk+5uHztxrGSU88ODvkTkz7rI4sM6yNECh3K0qs043uZblj7yJYuqNIqpRlMm8+
 wzDwCwv3byMIF8oUfqqasxbuQ3TtDWos7gZQJGVKhNIC2LVmjCnZo2JkYyax/FYs
 e2fZU8U1A6ZBspvQ3XhLcMQySybmxhPjLEvdspHRN7oqhwkZMGnR6QN5WW1hvtd6
 9FOQCFmlWWpN093yGofMN6jOp7DGJYnV8gjklE0Tcw==

On Wed, Nov 24, 2021 at 10:44:09AM +0100, Jan Kara wrote:
> On Tue 23-11-21 12:24:20, Luis Chamberlain wrote:
> > From: Xiaoming Ni <nixiaoming@huawei.com>
> > 
> > There is no need to user boiler plate code to specify a set of base
> > directories we're going to stuff sysctls under. Simplify this by using
> > register_sysctl() and specifying the directory path directly.
> > 
> > Move inotify_user sysctl to inotify_user.c while at it to remove clutter
> > from kernel/sysctl.c.
> > 
> > Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> > [mcgrof: update commit log to reflect new path we decided to take]
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> 
> This looks fishy. You register inotify_table but not fanotify_table and
> remove both...

Indeed, the following was missing, I'll roll it in:

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 559bc1e9926d..a35693eb1f36 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -59,7 +59,7 @@ static int fanotify_max_queued_events __read_mostly;
 static long ft_zero = 0;
 static long ft_int_max = INT_MAX;
 
-struct ctl_table fanotify_table[] = {
+static struct ctl_table fanotify_table[] = {
 	{
 		.procname	= "max_user_groups",
 		.data	= &init_user_ns.ucount_max[UCOUNT_FANOTIFY_GROUPS],
@@ -88,6 +88,13 @@ struct ctl_table fanotify_table[] = {
 	},
 	{ }
 };
+
+static void __init fanotify_sysctls_init(void)
+{
+	register_sysctl("fs/fanotify", fanotify_table);
+}
+#else
+#define fanotify_sysctls_init() do { } while (0)
 #endif /* CONFIG_SYSCTL */
 
 /*
@@ -1685,6 +1692,7 @@ static int __init fanotify_user_setup(void)
 	init_user_ns.ucount_max[UCOUNT_FANOTIFY_GROUPS] =
 					FANOTIFY_DEFAULT_MAX_GROUPS;
 	init_user_ns.ucount_max[UCOUNT_FANOTIFY_MARKS] = max_marks;
+	fanotify_sysctls_init();
 
 	return 0;
 }
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 616af2ea20f3..556cc63c88ee 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -5,8 +5,6 @@
 #include <linux/sysctl.h>
 #include <uapi/linux/fanotify.h>
 
-extern struct ctl_table fanotify_table[]; /* for sysctl */
-
 #define FAN_GROUP_FLAG(group, flag) \
 	((group)->fanotify_data.flags & (flag))
 

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
