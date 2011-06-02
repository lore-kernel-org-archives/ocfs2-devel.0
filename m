From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 02 Jun 2011 12:43:40 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: remove redundant and incorrect
	mlog_error
In-Reply-To: <20110601014303.GA5468@noexit.corp.google.com>
References: <1306514092-22962-1-git-send-email-tiger.yang@oracle.com>
	<20110601014303.GA5468@noexit.corp.google.com>
Message-ID: <4DE714FC.9060903@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/01/2011 09:43 AM, Joel Becker wrote:
> On Sat, May 28, 2011 at 12:34:52AM +0800, Tiger Yang wrote:
>> We have already mlog all error and positive status is not error.
> 	Positive status is turned into -EIO.  There are actually a
> couple of places in this function that do not mlog_errno(status) and
> rely on this print.  I think you should add them to your patch.
> 	For example:
>
> 371         status = ocfs2_qinfo_lock(oinfo, 0);
> 372         if (status<  0)
> 373                 goto out_unlock;
>
> Joel
>
>
Hi, Joel,
There is something devious about this function.
1 If status == sizeof(struct ocfs2_global_disk_dqinfo)) then positive 
status will be return.
2 After goto out_unlock, they goto out_err again.
I make a new one to fix this.  please review the attached patch.

Thanks,
Tiger


-------------- next part --------------
An embedded and charset-unspecified text was scrubbed...
Name: 0001-ocfs2-remove-redundant-and-incorrect-mlog_error.patch
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20110602/88479be9/attachment.pl 
