From: John L. Villalovos <john.l.villalovos@intel.com>
Date: Tue Mar 23 12:30:06 2004
Subject: [Ocfs2-devel] Patch to fix error if mount fails
Message-ID: <40608223.5020404@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I had an issue where if the mount failed after the threads had started that the thread would crash later on.

This patch makes sure that the NM thread is terminated if the mount fails and the thread has been started.

I didn't really see an easy way to terminate the listener thread :(

John

Index: super.c
===================================================================
--- super.c     (revision 803)
+++ super.c     (working copy)
@@ -868,6 +868,7 @@
         ocfs_vol_label *vol_label = NULL;
         int child_pid, i;
         struct buffer_head *bhs[] = { NULL, NULL };
+        int nm_thread_created = 0;        // keep track if the NM thread has been created

         LOG_ENTRY ();

@@ -973,6 +974,7 @@
         } else {
                 init_completion (&osb->dlm_complete);
         }
+        nm_thread_created = 1;

         /* Launch the commit thread */
         osb->commit = (ocfs_commit_task *)ocfs_malloc(sizeof(ocfs_commit_task));
@@ -1080,6 +1082,22 @@
                         OCFS_BH_PUT_DATA(bhs[1]);
                 brelse(bhs[1]);
         }
+        // If we failed to mount and we created the NM thread then we need to
+        // have it terminate
+        if (status<0 && nm_thread_created)
+        {
+                /* Dismount */
+                OCFS_SET_FLAG (osb->osb_flags, OCFS_OSB_FLAGS_BEING_DISMOUNTED);
+                osb->vol_state = VOLUME_BEING_DISMOUNTED;
+
+                /* Wait for this volume's NM thread to exit */
+                if (osb->dlm_task) {
+                        LOG_TRACE_STR ("Waiting for ocfs2nm to exit....");
+                        send_sig (SIGINT, osb->dlm_task, 0);
+                        wait_for_completion (&(osb->dlm_complete));
+                        osb->dlm_task = NULL;
+                }
+        }
         LOG_EXIT_STATUS (status);
         return status;
  }                              /* ocfs_mount_volume */
