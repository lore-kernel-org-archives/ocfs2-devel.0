From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 22 Feb 2011 01:32:13 -0800
Subject: [Ocfs2-devel] forget_all_cached_acls()
Message-ID: <20110222093212.GF30966@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hey everyone,
	I just found out from Steven over in GFS2 that there is a kernel
call forget_all_cached_acls().  If a cluster filesystem is using ACL
caching (added by Viro a little while back), they use
forget_all_cached_acls() at lock drop time to make sure they don't have
stale ACL info.
	We're not using cached_acls yet, but if someone adds it, please
remember this call ;-)

Joel

-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

			http://www.jlbec.org/
			jlbec at evilplan.org
