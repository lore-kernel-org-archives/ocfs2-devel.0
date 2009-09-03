From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 3 Sep 2009 12:12:32 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Use MAY_CREATE in
 ocfs2_permission()
In-Reply-To: <4A9F1FCB.5020406@oracle.com>
References: <1251940014-20963-1-git-send-email-joel.becker@oracle.com>
	<1251940014-20963-3-git-send-email-joel.becker@oracle.com>
	<4A9F1FCB.5020406@oracle.com>
Message-ID: <20090903191232.GA11525@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, ocfs2-devel@oss.oracle.com, linux-fsdevel@kernel.org

On Wed, Sep 02, 2009 at 06:45:47PM -0700, Sunil Mushran wrote:
> Joel Becker wrote:
> >@@ -1108,6 +1117,10 @@ int ocfs2_permission(struct inode *inode, int mask)
> > 	ret = generic_permission(inode, mask, ocfs2_check_acl);
> > 	ocfs2_inode_unlock(inode, 0);
> >+
> >+	if (mask & MAY_CREATE)
> >+		ocfs2_unblock_signals(&oldset);
> >+
> > out:
> > 	mlog_exit(ret);
> > 	return ret;
> 
> Maybe I am missing something but shouldn't we be unblocking the signal
> after the out label.

	Yes.

Joel

-- 

"Heav'n hath no rage like love to hatred turn'd, nor Hell a fury,
 like a woman scorn'd."
        - William Congreve

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
