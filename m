From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 13 Apr 2010 18:58:19 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
 to buffered
In-Reply-To: <201004081547.24593.lidongyang@novell.com>
References: <201004081547.24593.lidongyang@novell.com>
Message-ID: <20100414015819.GE5530@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 08, 2010 at 03:47:24PM +0800, Li Dongyang wrote:
> when we fall back to buffered write from direct write, we call
> __generic_file_aio_write but that will end up doing direct write
> even we are only prepared to do buffered write because the file
> has O_DIRECT flag set. This is a fix for
> https://bugzilla.novell.com/show_bug.cgi?id=591039

	We need to evaluate what __g_f_a_w() is doing and make sure
we're matching it appropriately for ocfs2.

> +	ret = file_remove_suid(file);
> +	if (ret)
> +		goto out_dio;

	NAK.  We do suid checks in ocfs2_prepare_inode_for_write().
Calling file_remove_suid() is outside of ocfs2's locking.  It calls
->setattr() which has its own rules in ocfs2.

> +	file_update_time(file);

	We have special behaviors regarding time updates for ocfs2
direct I/O.  This might want to live right next to the call to
generic_file_buffered_write().  But maybe not.  It needs to be checked.

Joel

-- 

To spot the expert, pick the one who predicts the job will take the
longest and cost the most.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
