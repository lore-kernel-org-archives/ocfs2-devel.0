From: shencanquan <shencanquan@huawei.com>
Date: Sun, 16 Jun 2013 09:57:24 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Fix llseek() semantics and do
 some cleanup
In-Reply-To: <51BD0A66.4070003@gentoo.org>
References: <1371237814-59365-1-git-send-email-ryao@gentoo.org>
	<1371237814-59365-2-git-send-email-ryao@gentoo.org>
	<51BBF6FE.6080502@oracle.com> <51BC080D.1090405@huawei.com>
	<51BD0A66.4070003@gentoo.org>
Message-ID: <51BD1B84.9080402@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Yao <ryao@gentoo.org>
Cc: Jeff Liu <jeff.liu@oracle.com>, Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org, kernel@gentoo.org, linux-fsdevel@vger.kernel.org, Ocfs2-Devel <ocfs2-devel@oss.oracle.com>

On 2013/6/16 8:44, Richard Yao wrote:
> On 06/15/2013 02:22 AM, shencanquan wrote:
>> Hello, Richard and Jeff,
>>     we found that llseek has another bug when in SEEK_END.  it should be
>> add the inode lock and unlock.
>>     this bug can be reproduce the following scenario:
>>     on one nodeA, open the file and then write some data to file and
>> close the file .
>>     on  another nodeB , open the file and llseek the end of file . the
>> position of file is old.
> Did these operations occur sequentially or did they occur concurrently?
>
> If you meant the former, the inode cache is not being invalidated. That
> should be a bug because Oracle claims OCFS2 is cache-coherent. However,
> it is possible that this case was left out of the cache-coherence
> protocol for performance purposes. If that is the case, then this would
> be by design. someone who works for Oracle would need to comment on that
> though.

    it is a occur sequentially.  after close the file on NodeA , on 
nodeB and then open the file and llseek the end of file.

>
> If you meant the latter, you should ask yourself what would happen when
> you run two separate programs on the same file in a local filesystem.
> There should be no way to avoid a race without some kind of a locking
> mechanism.
>
