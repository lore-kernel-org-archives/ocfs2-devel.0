From: Li Zefan <lizefan@huawei.com>
Date: Thu, 31 Jan 2013 10:10:17 +0800
Subject: [Ocfs2-devel] [PATCH 0/4 v2] Fix possible use after free with
	AIO
In-Reply-To: <20130130144535.GK4503@ZenIV.linux.org.uk>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
	<20130130144535.GK4503@ZenIV.linux.org.uk>
Message-ID: <5109D289.1050708@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

On 2013/1/30 22:45, Al Viro wrote:
> On Wed, Jan 30, 2013 at 12:27:57AM +0100, Jan Kara wrote:
>>
>>   Hi,
>>
>>   since nobody seem to have picked up any of the patches (at least
>> nobody told me so), I've added acks I received to the patches and I'm
>> sending them to Al for merging. Al, can you please merge these? Thanks.
> 
> VFS part (4/4) picked; IMO at least ext* and xfs should go through the
> filesystem trees.  If ocfs2 folks don't pick fs/ocfs2 part, I'll grab
> it as well - not sure how active their tree is these days...

I would say just grab it.

We've been sending bug fixes to ocfs2 mailing list since Aug 2012, but none
was pushed into upstream.
