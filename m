From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 13 Feb 2014 12:48:29 -0800
Subject: [Ocfs2-devel] [patch 04/11] ocfs2: fix a tiny race when
	running	dirop_fileop_racer
In-Reply-To: <52FC55B6.7020403@huawei.com>
References: <20140124204703.AF70F5A4203@corp2gmr1-2.hot.corp.google.com>
	<20140212232921.GZ24361@wotan.suse.de>
	<52FC55B6.7020403@huawei.com>
Message-ID: <20140213204829.GA5716@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 13, 2014 at 01:18:46PM +0800, Joseph Qi wrote:
> On 2014/2/13 7:29, Mark Fasheh wrote:
> >> @@ -1097,6 +1174,22 @@ static int ocfs2_rename(struct inode *ol
> >>  			goto bail;
> >>  		}
> >>  		rename_lock = 1;
> >> +
> >> +		/* here we cannot guarantee the inodes haven't just been
> >> +		 * changed, so check if they are nested again */
> >> +		status = ocfs2_check_if_ancestor(osb, new_dir->i_ino,
> >> +				old_inode->i_ino);
> >> +		if (status < 0) {
> >> +			mlog_errno(status);
> >> +			goto bail;
> >> +		} else if (status == 1) {
> >> +			status = -EPERM;
> >> +			mlog(ML_ERROR, "src inode %llu should not be ancestor "
> >> +				"of new dir inode %llu\n",
> >> +				(unsigned long long)old_inode->i_ino,
> >> +				(unsigned long long)new_dir->i_ino);
> > 
> > Is it possible for the user to trigger this mlog(ML_ERROR, "....") print at
> > will? If so we need to make it a debug print otherwise we risk blowing up
> > systemlog when someone abuses rename().
> > 	--Mark
> > 
> > --
> > Mark Fasheh
> > 
> > 
> The nested condition can be constructed but it is rare, isn't it?
> And only one system log for one rename, so we log it as error message.

It's not the rarity of it happening "naturally" that I'm worried about. If
arguments to rename() can be constructed such that they trigger the print
then a misbehaving user or program can flood the system log with repeating
messages. We don't want to leave holes like that exposed - I can speak from
experience that it results in angry system admins :)
	--Mark

--
Mark Fasheh
