From: Zach Brown <zach.brown@oracle.com>
Date: Wed, 03 May 2006 17:29:22 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC - separate journal?
In-Reply-To: <445936FE.90401@google.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<445936FE.90401@google.com>
Message-ID: <44594AE2.9080802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Daniel Phillips wrote:

> Sorry about the lag.  Here's an easy feature nobody has mentioned so far, and
> from my reading isn't supported: separate journal, like Ext3.

Yeah, I think this would be a fine piece to have some day.

I'm not sure it's a high priority, though, given that the vast majority
of deployments are already using hardware that has either some form of
write caching or so many spindles that external journals just aren't
worth the time they take to configure.

I'd be interested in seeing more careful write ordering in JBD before
worrying about external journals, personally.

- z
