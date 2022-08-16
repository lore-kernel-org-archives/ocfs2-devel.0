Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF1DDC25B0E
	for <ocfs2-devel@archiver.kernel.org>; Tue, 16 Aug 2022 19:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pvfEjg1cOVWB13x8vJLvtlsOlC4kSCpLR3++EergIbI=;
 b=u1Y8mnLsNVObT7IQu0EOWdc5gbN5hEjqzMD58sRkXMnnjypghfv5WynWvyAMXeL+8C4mnZCViiyB
   Md0L6Skvu/CZ/vDEx303OP8nKp7dC+QuWaAMe1R5pZ9PME7Kk4wp0r1KxefO7XEAQNLP6ZX3NJhd
   YrTAg99L2L4TQp1H6CTeiTK1Safp7hNQmBs5b3va40z4A3fR7hoHxaGGuVr4Q3/EHGuIBnOJSXoz
   oesFUi+dfOUFU7FwRAiQdTVz+eNXm/b2SaC0b6MZtC0ELvQ9GzjxuvWb7iKP1S1YyIy4C8vpLHuN
   1o1fMC1mXhrr7ilCqx45BKYD8lmeeESYNTc30g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pvfEjg1cOVWB13x8vJLvtlsOlC4kSCpLR3++EergIbI=;
 b=MVK2ZrXp+fkgoEV9WfTGyohOaCi5EX1VXTDeas3WvtSBpSAR6SvHvrKuKrDuwsI6qV4RzENpLuuy
   WeYjCzIVFh9505ntVeYtuB6OTFp/hTNttDjjgAm+n460+/q7gHipRRoYoNfzVB+iMl+CekmMl9sk
   Qb+dtDqLVXI0jtZwDf7iJsjeBYqQdGXw+FMZ5qkSUWpTuVLrt/gnSDWm/CrfrbvkY/V1frqtsP2R
   pJKHU7Drs5fqaR4HxDrERLYBifszS/aB41f7ovNf8t/Ad/M5hQxRepGCkwDVJExnlEGqPq8AWBQx
   aDY/+lfjXKGU9b5SRgbd4dATszhW7AiHiD/Xhg==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220805 64bit (built Aug  5
 2022))
 with ESMTPS id <0RGQ00C2X2OEYB80@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 16 Aug 2022 19:12:14 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=j3XcZj58ibAYo7JZ+DBGHbio8/+pmx+vaIAoYTPhszo=; b=C3ggZZuTRiGe+co72VGz5WtuLJ
 dEtZCyVzUM/eFKokG1H5+2fq5HnCQW1/XI3EnYPaBS8QQO9lxUZ1VUrcCmag9//Qh8vNBLfpz1mMI
 wPIz1JuLFLurE6ZIBrsfqaJgC46BC+tsi/iCNppteb7Iq1x5WwTqSgflaHVjt80Oo7N5zxT3TE7ME
 D47v+hXMewesjsDdRS0l90YMCI+ctr26b2bcQMrDuMV6Ik31zqsKLqtPZE7xiBkUAxOrYhr8aM+3U
 v9TQa3ty7tM2bpDblyqo+kJk2VdOjZI+nsGlYX6risKRNaTbeuVXpiySdoN5yJ2RptQrlEc7NFx1l
 ZR3SyIng==;
Date: Tue, 16 Aug 2022 20:11:31 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <Yvvr447B+mqbZAoe@casper.infradead.org>
References: <YvvBs+7YUcrzwV1a@ZenIV>
 <CAHk-=wgkNwDikLfEkqLxCWR=pLi1rbPZ5eyE8FbfmXP2=r3qcw@mail.gmail.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to:
 <CAHk-=wgkNwDikLfEkqLxCWR=pLi1rbPZ5eyE8FbfmXP2=r3qcw@mail.gmail.com>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10441
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=39 mlxlogscore=20
 lowpriorityscore=0 malwarescore=0 clxscore=200 mlxscore=39 suspectscore=0
 adultscore=0 phishscore=0 spamscore=39 bulkscore=0 impostorscore=0
 priorityscore=243 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160071
Cc: jfs-discussion@lists.sourceforge.net, Hans de Goede <hdegoede@redhat.com>,
 devel@lists.orangefs.org, apparmor@lists.ubuntu.com,
 linux-unionfs@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu,
 linux-security-module@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
 Sungjong Seo <sj1557.seo@samsung.com>, Namjae Jeon <linkinjeon@kernel.org>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] Switching to iterate_shared
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
From: Matthew Wilcox via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Matthew Wilcox <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: iv2gANjS5QRXymHqqKthpIR93YH9737t
X-Proofpoint-ORIG-GUID: iv2gANjS5QRXymHqqKthpIR93YH9737t
Reporting-Meta:
 AAEeYI44+nFhq068S/x7cAKVTyX7Wn8xzPUUGPSWOQyhJdXwlGGqTbUoxnQz+bU4
 xYC5rqcAgunGvlsrBqgAnV+jqPoiQv64NQ86cjKqQcljYMEY2+s3B+WhPsx6eP4o
 SdIzc/htU9Rf1rwXhBxYG3lkd2dq3n1lAkcLUov0dk4IHSxBgDT7a7VS7smxZi5y
 or5iSxe1aM4aGIlhczRYhBZoN45Xi35gFkcwUlJh/K9LL4wulcizV9hpz+nxMQx9
 gVt5VjXvDpulnxYPJc4458MgorvDfI/3LWEqv2OHcCEtPLarq0T59s9W9033nMi7
 LWOkBs/7D+F1d6c9M7D1Qz1x3bDaG5e/NyZqWqDJ9Us6VD6r47AKCY2DIUIYGgEQ
 ufyFmHdmVWuWpbR2ePKq/l8m5vIRH112dI8kUwntHd4ZKNGu2RGh0MkXNomWteXK
 3EZXn1DTLX3r+X3XymKQWewPiCld1r6p+LHinGj5E+RK3mgG8GZVW0+B/J7/F9Wq
 nvOWXpN3Jn066wbMXAa3TvzQede4WsQg1oLGn8eiGNc=

On Tue, Aug 16, 2022 at 11:58:36AM -0700, Linus Torvalds wrote:
> That said, our filldir code is still confusing as hell. And I would
> really like to see that "shared vs non-shared" iterator thing go away,
> with everybody using the shared one - and filesystems that can't deal
> with it using their own lock.
> 
> But that's a completely independent wart in our complicated filldir saga.
> 
> But if somebody were to look at that iterate-vs-iterate_shared, that
> would be lovely. A quick grep shows that we don't have *that* many of
> the non-shared cases left:
> 
>       git grep '\.iterate\>.*='
> 
> seems to imply that converting them to a "use my own load" wouldn't be
> _too_ bad.
> 
> And some of them might actually be perfectly ok with the shared
> semantics (ie inode->i_rwsem held just for reading) and they just were
> never converted originally.

What's depressing is that some of these are newly added.  It'd be
great if we could attach something _like_ __deprecated to things
that checkpatch could pick up on.

fs/adfs/dir_f.c:        .iterate        = adfs_f_iterate,
fs/adfs/dir_fplus.c:    .iterate        = adfs_fplus_iterate,

ADFS is read-only, so must be safe?

fs/ceph/dir.c:  .iterate = ceph_readdir,
fs/ceph/dir.c:  .iterate = ceph_readdir,

At least CEPH has active maintainers, cc'd

fs/coda/dir.c:  .iterate        = coda_readdir,

Would anyone notice if we broke CODA?  Maintainers cc'd anyway.

fs/exfat/dir.c: .iterate        = exfat_iterate,

Exfat is a new addition, but has active maintainers.

fs/jfs/namei.c: .iterate        = jfs_readdir,

Maintainer cc'd

fs/ntfs/dir.c:  .iterate        = ntfs_readdir,         /* Read directory contents. */

Maybe we can get rid of ntfs soon.

fs/ocfs2/file.c:        .iterate        = ocfs2_readdir,
fs/ocfs2/file.c:        .iterate        = ocfs2_readdir,

maintainers cc'd

fs/orangefs/dir.c:      .iterate = orangefs_dir_iterate,

New; maintainer cc'd

fs/overlayfs/readdir.c: .iterate        = ovl_iterate,

Active maintainer, cc'd

fs/proc/base.c: .iterate        = proc_##LSM##_attr_dir_iterate, \

Hmm.  We need both SMACK and Apparmor to agree to this ... cc's added.

fs/vboxsf/dir.c:        .iterate = vboxsf_dir_iterate,

Also newly added.  Maintainer cc'd.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
