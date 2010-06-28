From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 29 Jun 2010 07:16:10 +0800
Subject: [Ocfs2-devel] [PATCH 0/3 v5][RFC] ext3/4: enhance fsync
 performance when using CFQ
In-Reply-To: <x49hbknfeck.fsf@segfault.boston.devel.redhat.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>	<4C21D442.8080703@oracle.com>
	<4C22F316.3080009@oracle.com>	<x49k4pk60ye.fsf@segfault.boston.devel.redhat.com>	<4C284419.3000905@oracle.com>
	<x49hbknfeck.fsf@segfault.boston.devel.redhat.com>
Message-ID: <4C292D3A.5000208@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-ext4@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, linux-kernel@vger.kernel.org, vgoyal@redhat.com

Jeff Moyer wrote:
> Tao Ma <tao.ma@oracle.com> writes:
>
>   
>> btw, I also met with a NULL pointer deference in cfq_yield. I have
>> attached the null.log also. This seems to be related to the previous
>> deadlock and happens when I try to remount the same volume after
>> reboot and ocfs2 try to do some recovery.
>>     
>
> Since I can't reproduce your binary kernel even with your .config, could
> you send me the disassembly of the cfq_yield function from your vmlinux
> binary?
>   
no problem. I have attached it.
btw, if you have any debug patch, I am happy to run it to make the 
problem more clear to you.

Regards,
Tao
-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: cfq_yield.txt
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100629/d0590f1f/attachment.txt 
