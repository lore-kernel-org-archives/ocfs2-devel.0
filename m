From: Jan Kara <jack@suse.cz>
Date: Wed, 29 Jul 2009 12:37:41 +0200
Subject: [Ocfs2-devel] ocfs2 quota qs.
In-Reply-To: <4A70108E.5000108@oracle.com>
References: <4A70108E.5000108@oracle.com>
Message-ID: <20090729103741.GG19209@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 29-07-09 17:04:14, Tao Ma wrote:
> Hi Jan,
> 	I am now reading quota support in ocfs2 and have some qs. Wish you can 
> help me clarify it. Thanks.
>
> ocfs2_quota_write:
> 	In the comment, you said that "we know the transaction is already 
> started", so it should be called within a transaction. But in this 
> function, we call ocfs2_extend_no_holes and ocfs2_simple_size_update which 
> will start another transaction. So we can survive with nested transaction 
> or this scenario will never happen?
  The comment is right, we absolutely require a transaction being started
when when entering ocfs2_quota_write(), otherwise deadlocks could occur.
  JBD supports nested transactions - when journal_start() is called and
the current process already has a transaction open, it just returns the
currently open transaction. So you only have to be sure to initially ask
for enough credits when opening the transaction - and quota code hopefully
gets this right.
  Hmm, but looking at the code again, there's one catch - normally,
allocator locks nest outside the transaction and in ocfs2_quota_write()
they are acquired inside the transaction and that can lead to deadlocks.
Aw, that's going to be nasty to fix... I have to rethink the locking
logic...
  Thanks for your inquiry :)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
