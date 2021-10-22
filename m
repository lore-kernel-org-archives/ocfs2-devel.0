Return-Path: <SRS0=RLPq=PK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6EAC433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 22 Oct 2021 18:10:11 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C58626121F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 22 Oct 2021 18:10:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C58626121F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MI75M8027918;
	Fri, 22 Oct 2021 18:10:09 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3buta8aphs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 18:10:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19MI5grf066708;
	Fri, 22 Oct 2021 18:10:08 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3br8gyau3g-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 22 Oct 2021 18:10:08 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mdywU-0006RN-5F; Fri, 22 Oct 2021 11:06:58 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cmarinas@kernel.org>) id 1mdywS-0006Qz-MU
	for ocfs2-devel@oss.oracle.com; Fri, 22 Oct 2021 11:06:56 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19MI5l12158899
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 18:06:56 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3bqkv45kdw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 18:06:56 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19MHFjRw001543
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 18:06:55 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bv1hu0jk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Fri, 22 Oct 2021 18:06:54 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32ED1610A4;
	Fri, 22 Oct 2021 18:06:49 +0000 (UTC)
Date: Fri, 22 Oct 2021 19:06:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YXL9tRher7QVmq6N@arm.com>
References: <20211019134204.3382645-1-agruenba@redhat.com>
	<CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
	<YXBFqD9WVuU8awIv@arm.com>
	<CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
	<CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx include:_spf.kernel.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10145
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 00/17] gfs2: Fix mmap + page fault
	deadlocks
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10145 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220105
X-Proofpoint-GUID: 29UY6q3LpYtNGMEwi0Pme6YB3rSW7LNO
X-Proofpoint-ORIG-GUID: 29UY6q3LpYtNGMEwi0Pme6YB3rSW7LNO

On Wed, Oct 20, 2021 at 08:19:40PM -1000, Linus Torvalds wrote:
> On Wed, Oct 20, 2021 at 12:44 PM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> >
> > However, with MTE doing both get_user() every 16 bytes and
> > gup can get pretty expensive.
> 
> So I really think that anything that is performance-critical had
> better only do the "fault_in_write()" code path in the cold error path
> where you took a page fault.
[...]
> So I wouldn't worry too much about the performance concerns. It simply
> shouldn't be a common or hot path.
> 
> And yes, I've seen code that does that "fault_in_xyz()" before the
> critical operation that cannot take page faults, and does it
> unconditionally.
> 
> But then it isn't the "fault_in_xyz()" that should be blamed if it is
> slow, but the caller that does things the wrong way around.

Some more thinking out loud. I did some unscientific benchmarks on a
Raspberry Pi 4 with the filesystem in a RAM block device and a
"dd if=/dev/zero of=/mnt/test" writing 512MB in 1MB blocks. I changed
fault_in_readable() in linux-next to probe every 16 bytes:

- ext4 drops from around 261MB/s to 246MB/s: 5.7% penalty

- btrfs drops from around 360MB/s to 337MB/s: 6.4% penalty

For generic_perform_write() Dave Hansen attempted to move the fault-in
after the uaccess in commit 998ef75ddb57 ("fs: do not prefault
sys_write() user buffer pages"). This was reverted as it was exposing an
ext4 bug. I don't whether it was fixed but re-applying Dave's commit
avoids the performance drop.

btrfs_buffered_write() has a comment about faulting pages in before
locking them in prepare_pages(). I suspect it's a similar problem and
the fault_in() could be moved, though I can't say I understand this code
well enough.

Probing only the first byte(s) in fault_in() would be ideal, no need to
go through all filesystems and try to change the uaccess/probing order.

-- 
Catalin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
