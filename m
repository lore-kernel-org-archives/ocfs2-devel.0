From: Li Dongyang <lidongyang@novell.com>
Date: Wed, 14 Apr 2010 15:42:31 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
	to buffered
In-Reply-To: <20100414015819.GE5530@mail.oracle.com>
References: <201004081547.24593.lidongyang@novell.com>
	<20100414015819.GE5530@mail.oracle.com>
Message-ID: <201004141542.31733.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wednesday 14 April 2010 09:58:19 Joel Becker wrote:
> On Thu, Apr 08, 2010 at 03:47:24PM +0800, Li Dongyang wrote:
> > when we fall back to buffered write from direct write, we call
> > __generic_file_aio_write but that will end up doing direct write
> > even we are only prepared to do buffered write because the file
> > has O_DIRECT flag set. This is a fix for
> > https://bugzilla.novell.com/show_bug.cgi?id=591039
> 
> 	We need to evaluate what __g_f_a_w() is doing and make sure
> we're matching it appropriately for ocfs2.
> 
Thanks for reviewing, that's just the two uncertain points to me with the patch.
> > +	ret = file_remove_suid(file);
> > +	if (ret)
> > +		goto out_dio;
> 
> 	NAK.  We do suid checks in ocfs2_prepare_inode_for_write().
> Calling file_remove_suid() is outside of ocfs2's locking.  It calls
> ->setattr() which has its own rules in ocfs2.
you are right, I did that because we are calling __g_f_a_w() in o_f_a_w()
which will call file_remove_suid() before.
> 
> > +	file_update_time(file);
> 
> 	We have special behaviors regarding time updates for ocfs2
> direct I/O.  This might want to live right next to the call to
> generic_file_buffered_write().  But maybe not.  It needs to be checked.
I don't think we need that, as we will update the time in ocfs2_write_end_nolock()
called by ocfs2_write_end().
and could I have more details on how we handle time updates for ocfs2 direct io?
Br,
Li Dongyang
> 
> Joel
> 
