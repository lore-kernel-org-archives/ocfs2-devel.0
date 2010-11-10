From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 10 Nov 2010 22:19:40 +0800
Subject: [Ocfs2-devel] [PATCH 2/5] ocfs2: Remove ENTRY from masklog.
In-Reply-To: <20101110094335.GC31158@mail.oracle.com>
References: <4CDA08B6.2070002@oracle.com>
	<1289357543-2538-2-git-send-email-tao.ma@oracle.com>
	<20101110094335.GC31158@mail.oracle.com>
Message-ID: <4CDAA9FC.9070606@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Wed, Nov 10, 2010 at 10:52:20AM +0800, Tao Ma wrote:
>   
>> ENTRY is used to record the entry of a function.
>> But because it is added in so many functions, if we enable it,
>> the system logs get filled up quickly and cause too much I/O.
>> So actually no one can open it for a production system or even
>> for a test.
>>
>> So for mlog_entry_void, we just remove it.
>> for mlog_entry(...), we replace it with mlog(0,...).
>>     
>
> 	I'm not sure I like this.  One of the benefits of mlog_entry()
> was that you could turn on ML_xxx and not see these entry lines.  By
> replacing it with mlog(0, ...), all of those entry lines will appear if
> the file is enabled.
> 	I realize that many of them will be replaced in later patches.
> I just hope they all are ;-)
>   
Yeah, I will replace them with trace events later.

But you are right that the commit log should explain it. I will add some 
more comments in the next round.

Regards,
Tao
