From: Gang He <ghe@suse.com>
Date: Fri, 05 Feb 2016 18:02:28 -0700
Subject: [Ocfs2-devel] [PATCH v3 4/4] ocfs2: check/fix inode block for
 online file check
In-Reply-To: <20160205230533.GB1239@wotan.suse.de>
References: <56A62D15020000F9000270A2@relay2.provo.novell.com>
	<20160204004510.GI24672@wotan.suse.de>
	<56B5158B020000F900022289@relay2.provo.novell.com>
	<20160205230533.GB1239@wotan.suse.de>
Message-ID: <56B5B6A4020000F90002237B@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Mark,

Thanks for your comments.

-Gang


>>> 
> On Fri, Feb 05, 2016 at 06:35:07AM -0700, Gang He wrote:
>> Hi Mark,
>> 
>> 
>> >>> 
>> > On Sun, Jan 24, 2016 at 11:11:33PM -0700, Gang He wrote:
>> >> >> Also, I'm concerned that the buffer in question might be journaled. In 
> that 
>> > 
>> >> >> case, writing it to disk like this could cause corruptions (if the buffer
>> >> >> contains not-committed changes). 
>> >> > I ever though of journaling this changed inode block in case file check 
>> >> > fixing, but you know, we are being on inode block loading stage, the 
>> > journal 
>> >> > related structs are not prepared at this moment, then I write this block 
>> > back 
>> >> > to the disk synchronously within ocfs2_inode_lock, it looks a little 
>> > tricky, 
>> >> > but not bring any risk. in case the machine crashes when writing the inode 
> 
>> >> > block back to the disk, this will not affect file system integrity, since 
>> >> > this inode block original is corrupted, the user can fix this inode block 
>> > via 
>> >> > file check again after the machine is recovered.
>> >> > Anyway, I just want to let all know what I think behind this part code, 
>> >> > maybe it is not right, please give your feedback again.
>> > 
>> > So the problem is a buffer that might exist and be journaled without the 
>> > inode being in
>> > memory. I'm not clear on whether we would hit this (even if we did it would
>> > be rare). It might be easiest if you could test the buffer with 
> buffer_jbd()
>> > and warn then return an error to see if we ever even hit that case.
>> Thank for your comments, I can add this test buffer_jbd() in code, to avoid 
> such race condition (though I feel there is not possibility).
>> Besides the comments above, do you have any other comments for this part 
> code? 
>> I will submit a updated patches after Chinese New Year holiday. 
> 
> No, I think it looks good overall. You should have my reviewed-by for most
> of the patches by now, so it's just this one if I remember?
> 	--Mark
> 
> --
> Mark Fasheh
