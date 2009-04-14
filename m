From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 14 Apr 2009 16:39:35 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2_controld: Handle simultaneous group
	join.
In-Reply-To: <20090408222237.GC8561@mail.oracle.com>
References: <20090408213317.GC11662@redhat.com>
	<20090408222237.GC8561@mail.oracle.com>
Message-ID: <20090414233935.GF6692@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

More than one ocfs2_controld can join the cpg group at the same time,
even for the first members of a group.  So 'jouners == 1' is not a valid
check to see if this controld is the first one.

We change the code to pick the controld with the lowest node number to
set up the daemon control group.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 ocfs2_controld/cpg.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/ocfs2_controld/cpg.c b/ocfs2_controld/cpg.c
index a2d8ae1..5e166b0 100644
--- a/ocfs2_controld/cpg.c
+++ b/ocfs2_controld/cpg.c
@@ -728,6 +728,8 @@ out:
 
 static void daemon_set_cgroup(struct cgroup *cg, void *user_data)
 {
+	int i, first = 1;
+
 	void (*daemon_joined)(int first) = user_data;
 
 	if (cg != &daemon_group) {
@@ -735,7 +737,16 @@ static void daemon_set_cgroup(struct cgroup *cg, void *user_data)
 		return;
 	}
 
-	daemon_joined(daemon_group.cg_member_count == 1);
+	if (daemon_group.cg_cb_member_count != daemon_group.cg_cb_joined_count)
+		first = 0;
+	else {
+		for (i = 0; i < daemon_group.cg_cb_joined_count; i++) {
+			if (daemon_group.cg_cb_joined[i].nodeid < our_nodeid)
+				first = 0;
+		}
+	}
+
+	daemon_joined(first);
 }
 
 int setup_cpg(void (*daemon_joined)(int first))
-- 
1.6.1.3

-- 

Life's Little Instruction Book #139

	"Never deprive someone of hope; it might be all they have."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
