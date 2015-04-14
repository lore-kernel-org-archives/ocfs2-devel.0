From: Jan Kara <jack@suse.cz>
Date: Tue, 14 Apr 2015 10:43:56 +0200
Subject: [Ocfs2-devel] A question about function jbd2__journal_restart()
In-Reply-To: <552C82B9.7060305@huawei.com>
References: <552C82B9.7060305@huawei.com>
Message-ID: <20150414084356.GC23327@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xue jiufei <xuejiufei@huawei.com>
Cc: linux-ext4@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

  Hello,

On Tue 14-04-15 11:00:09, Xue jiufei wrote:
> I have a question about function jbd2__journal_restart().
> If we call this function when there's not more credits,
> it may commit the handle's transaction and start another one.
> So a handle can be attached to 2 transaction and can not ensure the
> consistency. It is the caller's responsibility to keep things consistently
> before call jbd2__journal_restart(), right?
  Correct.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
