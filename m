From: Tristan Ye <tye.kernel@gmail.com>
Date: Tue, 22 Jan 2013 20:03:09 +0800
Subject: [Ocfs2-devel] NULL pointer deref in OCFS2_IOC_MOVE_EXT
In-Reply-To: <CADGQE7HNSWGThWEudE6Hmu2ws6yFPmSxZRrwbXs7vrkFXD4Qwg@mail.gmail.com>
References: <CADGQE7HNSWGThWEudE6Hmu2ws6yFPmSxZRrwbXs7vrkFXD4Qwg@mail.gmail.com>
Message-ID: <CAPEeBxr55+LBgX4Dw7NT1R=JuUb4s9iM=4nj5-7vCD_iSsmELg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Nickolai,,

Thanks for reporting this issue, which seems to be a code bug here, the
proper fix proabably might be referencing 'dg' after it has been assigined.

Regards,
Tristan
On Wed, Jan 9, 2013 at 12:11 AM, Nickolai Zeldovich
<nickolai@csail.mit.edu>wrote:

> It appears that if a user calls ioctl(OCFS2_IOC_MOVE_EXT) and does not
> set OCFS2_MOVE_EXT_FL_AUTO_DEFRAG in range.me_flags, the kernel will
> invoke ocfs2_validate_and_adjust_move_goal.  That function
> dereferences the 'bg' pointer (initialized to NULL) before it assigns
> anything else to 'bg'.
>
> One possible fix is to revert
> ea5e1675ac832b42889ac8d254ea8fbfbdfaa8b2, which is when the code in
> ocfs2_validate_and_adjust_move_goal was moved in a way that guaranteed
> a NULL pointer dereference.  But I don't fully understand what that
> change was trying to achieve.
>
> Nickolai.
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130122/f30ba8e4/attachment.html 
