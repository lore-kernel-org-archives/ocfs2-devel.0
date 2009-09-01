From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 1 Sep 2009 01:28:17 -0700
Subject: [Ocfs2-devel] [PATCH 02/14] ocfs2: Remove xattrs via
	ocfs2_xa_loc
In-Reply-To: <4A9CB94B.1010003@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-3-git-send-email-joel.becker@oracle.com>
	<4A9CB94B.1010003@oracle.com>
Message-ID: <20090901082817.GB3826@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 01, 2009 at 02:03:55PM +0800, Tao Ma wrote:
> >+	if (count) {
> >+		index = ((char *)entry - (char *)&xh->xh_entries) /
> >+			sizeof(struct ocfs2_xattr_entry);
> 	index = entry - xh->xh_entries should work?

	Yes, but I never use that C math, because it confuses people.
Converting to char* means it's byte math.

Joel

-- 

Life's Little Instruction Book #30

	"Never buy a house without a fireplace."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
