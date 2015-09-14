From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 14 Sep 2015 15:22:16 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fill-in the unused portion of the
 block with zeros by dio_zero_block()
In-Reply-To: <55F0E287.1020701@oracle.com>
References: <55EF9184.5090007@huawei.com>
	<55F0E287.1020701@oracle.com>
Message-ID: <20150914152216.f0eac2d700ab39911d0aedf3@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 10 Sep 2015 09:53:11 +0800 ryding <ryan.ding@oracle.com> wrote:

> Hi Yiwen,
> 
> I'm working on this issue. The patch will be send out soon. And the 
> issue that do not support file hole will be fixed too. I have proved it 
> can pass all ltp-aiodio test cases, and has better performance. ;-)

Yes, your "ocfs2: fill in the unused portion of the block with zeros by
dio_zero_block()" conflicts with this patch a little.

Does your patchset need alteration to fix this bug?
