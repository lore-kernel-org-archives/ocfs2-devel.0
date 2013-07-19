From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 19 Jul 2013 15:38:27 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: using i_size_read() to access
	i_size
In-Reply-To: <51E5D390.6040604@oracle.com>
References: <1373876172-6467-1-git-send-email-junxiao.bi@oracle.com>
	<51E4B86F.2040703@tao.ma> <51E5D390.6040604@oracle.com>
Message-ID: <51E8ECF3.7010905@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jeff,

On 07/17/2013 07:13 AM, Jeff Liu wrote:
>>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>>> >> index 3ce6a8b..7158710 100644
>>> >> --- a/fs/ocfs2/file.c
>>> >> +++ b/fs/ocfs2/file.c
>>> >> @@ -2650,7 +2650,7 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
> We have the inode mutex around ocfs2_file_llseek(), and that is too extensive
> to block the concurrent access for particular seek operations.  At least,
> we can get rid of this lock for SEEK_SET/SEEK_CUR. i.e,  In either case,
> we can fall through generic_file_llseek() directly without the mutex lock.
Think about this again, I think we can't remove the mutex, as it is used
to protect other inode member beside i_size, like
inode->i_sb->s_maxbytes which is accessed in all SEEK request and also
more in ocfs2_inode_lock().

Thanks,
Junxiao.
>
>>> >>  	case SEEK_SET:
>>> >>  		break;
>>> >>  	case SEEK_END:
>>> >> -		offset += inode->i_size;
>>> >> +		offset += i_size_read(inode);
