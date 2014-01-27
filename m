From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 27 Jan 2014 09:22:58 -0800
Subject: [Ocfs2-devel] [patch 01/11] ocfs2: fix ocfs2_sync_file()
	if	filesystem is readonly
In-Reply-To: <20140124143204.03ee21c5d6e9eabda00f9628@linux-foundation.org>
References: <20140124204700.532BA31C1B6@corp2gmr1-1.hot.corp.google.com>
	<52E2E2E1.2060601@suse.de> <20140124222119.GF24361@wotan.suse.de>
	<20140124143204.03ee21c5d6e9eabda00f9628@linux-foundation.org>
Message-ID: <20140127172258.GG24361@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 24, 2014 at 02:32:04PM -0800, Andrew Morton wrote:
> On Fri, 24 Jan 2014 14:21:19 -0800 Mark Fasheh <mfasheh@suse.de> wrote:
> 
> > On Fri, Jan 24, 2014 at 04:02:09PM -0600, Goldwyn Rodrigues wrote:
> > > 
> > > 
> > > On 01/24/2014 02:46 PM, akpm at linux-foundation.org wrote:
> > > > From: Younger Liu <younger.liucn@gmail.com>
> > > > Subject: ocfs2: fix ocfs2_sync_file() if filesystem is readonly
> > > >
> > > > If filesystem is readonly, there is no need to flush drive's caches or
> > > > force any uncommitted transactions.
> > > 
> > > An ocfs2 filesystem can be set to read-only because of an error, in 
> > > which case, you should return -EROFS.
> > > 
> > > Nak.
> > 
> > Goldwyn's right actually - disregard my sign off for the last one.
> > 
> > Basically the patch does this:
> > 
> >     if  (we're in some readonly state)
> > 	return 0;
> > 
> > What we want, at the top of ocfs2_sync_file() is a return of -EROFS. This
> > will satisfy Goldwyn's requirement that we bubble -EROFS up the stack but at
> > the same time avoiding the extra work of trying to sync on a RO fs.
> > 
> > So the new version of the patch would be:
> > 
> >     if  (we're in some readonly state)
> > 	return -EROFS;
> > 
> 
> So it's this?

Yes, that's exactly what I was thinking the patch should look like. If you
want to change it and include my signoff that's fine with me. Thanks,
	--Mark


> --- a/fs/ocfs2/file.c~ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly
> +++ a/fs/ocfs2/file.c
> @@ -185,6 +185,9 @@ static int ocfs2_sync_file(struct file *
>  			      file->f_path.dentry->d_name.name,
>  			      (unsigned long long)datasync);
>  
> +	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
> +		return -EROFS;
> +
>  	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
>  	if (err)
>  		return err;
> _
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
