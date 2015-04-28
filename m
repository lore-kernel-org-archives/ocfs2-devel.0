From: Gang He <ghe@suse.com>
Date: Mon, 27 Apr 2015 21:00:35 -0600
Subject: [Ocfs2-devel] [RFC] Online File(system) check
In-Reply-To: <20150427213227.GA28129@shrek.lan>
References: <20150427213227.GA28129@shrek.lan>
Message-ID: <553F6853020000F90000822C@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Glodwyn,

Very nice proposal.
So far, there are some comments from me.
1) which task will we do in check/fix a file, we need to define the detailed requirements further, since we just do a light-level file check/fix according to inode number, we need to know which items can be done by online check, which items can be done by offline fsck.
2) can we keep check and fix two option, check option is to check if a file is good or bad, but not modify anything, fix option is to check and fix a file if the file is corrupted.
3) when users execute the command "echo CHECK <inode> > /sys/fs/ocfs2/filecheck" to check a file, how to give the feedback information besides printing the messages to syslog?
4) we should support a list to accept the "check/fix" requests from user-space and queue them, then handle them one by one, right? what is the behavior for the request user which execute "echo check ..." from the user space? the user post a request to the kernel space, then the command will end or wait for the file check end?

Thanks
Gang


>>> 
> On popular demand, here is an RFC. If you think there is a better
> way to communicate with the kernel module for the check, please
> let me know.
> he
> 
> Intro
> -----
> OCFS2 is often used in high-availaibility systems. However, ocfs2
> converts the filesystem to read-only at the drop of the hat. This
> may not be necessary, since turning the filesystem read-only would
> affect other running processes as well, decreasing availability.
> 
> This attempt is to add errors=continue, which would return the EIO
> to the calling process and terminate furhter processing so that
> the filesystem is not corrupted further. However, the filesystem
> is not converted to read-only.
> 
> Scope
> -----
> This effort is to fix small issues which may hinder day-today operations
> of a cluster filesystem by turning the filesystem read-only. The scope of
> fixing is at the file level, initially for regular files and eventually
> to all files (including system files) of the filesystem.
> 
> In case of directory to file links is incorrect, the directory inode
> is reported as erroneous.
> 
> This feature is not suited for extravagant checks which involve dependency 
> of
> other components of the filesystem, such as but not limited to, checking if 
> the bits for file blocks in the allocation has been set. In case of such an 
> error,
> the offline fsck should/would be recommended.
> 
> Finally, such an operation/feature should not be automated lest the 
> filesystem
> may end up with more damage than before the repair attempt. So, this has to
> be performed using user interaction and consent.
> 
> 
> Communication
> -------------
> When there are errors in the ocfs2 filesystem, they are usually accompanied
> by the inode number which caused the error. This inode number would be the
> input to fixing the file.
> 
> One of these options could be considered:
> 
> A file in the sys filesytem which would accept inode numbers. This
> could be used to communication back what has to be fixed or is fixed.
> You could write:
>   # echo "CHECK <inode>" > /sys/fs/ocfs2/filecheck
>   or
>   # echo "FIX <inode>" > /sys/fs/ocfs2/filecheck
> 
> 
> Fixing stuff
> ------------
> 
> On receivng the inode, the filesystem would read the inode and the
> file metadata. In case of errors, the filesystem would fix the errors
> and report the problems it fixed. As a precautionary measure, the
> inode must first be checked for errors before performing a final fix.
> 
> The inode and the fix history will be maintained temporarily in a
> small linked list buffer which would contain the last (N) inodes
> fixed/checked, alongwith the logs of what errors were reported/fixed.
> 
> 
> Comments/Criticism welcome.
