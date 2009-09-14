From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 14 Sep 2009 12:44:05 -0700
Subject: [Ocfs2-devel] [PATCH] [RFC] Mount option trap for users
In-Reply-To: <20090914145622.GK24075@duck.suse.cz>
References: <20090914145622.GK24075@duck.suse.cz>
Message-ID: <20090914194404.GA28473@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Sep 14, 2009 at 04:56:22PM +0200, Jan Kara wrote:
>   OCFS2 mount option 'acl' is a small trap for users. When xattr feature
> is not enabled and 'acl' mount option is specified, it is just silently
> cleared during mount. IMHO that's not a good behavior - when admin requests
> ACLs and we are not able to provide them, we should just fail the mount.

	See
http://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg03836.html for
previous discussion.

Joel

-- 

Life's Little Instruction Book #450

	"Don't be afraid to say, 'I need help.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
