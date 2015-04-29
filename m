From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 29 Apr 2015 15:59:41 +0800
Subject: [Ocfs2-devel] [RFC] Online File(system) check
In-Reply-To: <20150427213227.GA28129@shrek.lan>
References: <20150427213227.GA28129@shrek.lan>
Message-ID: <55408F6D.5020908@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 04/28/2015 05:32 AM, Goldwyn Rodrigues wrote:
> On popular demand, here is an RFC. If you think there is a better
> way to communicate with the kernel module for the check, please
> let me know.
> 
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
Is this safe, if detected an error when accessing an inode, how do you
know this is only inode internal error? If there is corruptions in other
place, the fs will be corrupted further.

Thanks,
Junxiao.

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
> This feature is not suited for extravagant checks which involve dependency of
> other components of the filesystem, such as but not limited to, checking if the bits for file blocks in the allocation has been set. In case of such an error,
> the offline fsck should/would be recommended.
> 
> Finally, such an operation/feature should not be automated lest the filesystem
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
> 
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
