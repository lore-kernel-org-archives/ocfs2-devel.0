From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 29 Jan 2008 04:13:10 -0000
Subject: [Ocfs2-devel] [PATCH] [11/18] BKL-removal: Convert ocfs2 over
	to unlocked_ioctl II
In-Reply-To: <20080127021717.CE2C715044@wotan.suse.de> (Andi Kleen's message
	of "Sun\, 27 Jan 2008 03\:17\:17 +0100 \(CET\)")
References: <20080127317.043953000@suse.de>
	<20080127021717.CE2C715044@wotan.suse.de>
Message-ID: <p73r6g16zhy.fsf_-_@bingen.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Andi Kleen <ak@suse.de> writes:

> As far as I can see there is nothing in ocfs2_ioctl that requires the BKL,
> so use unlocked_ioctl

Mark, can you please ack/nack this patch and ideally take it into your
tree?  You're the only file system maintainer who hasn't acknowledged
yet.

Thanks,

-Andi
