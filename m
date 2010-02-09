From: Dan Carpenter <error27@gmail.com>
Date: Tue, 9 Feb 2010 11:09:44 +0300
Subject: [Ocfs2-devel] ocfs2: bug in dlm_process_recovery_data()
Message-ID: <20100209080944.GA13283@bicker>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I noticed a change was merged to dlm_process_recovery_data() so I 
thought you might want to fix this as well.

fs/ocfs2/dlm/dlmrecovery.c
  1788                                  list_for_each_entry(lock, tmpq, list) {
  1789                                          if (lock->ml.cookie != ml->cookie)
  1790                                                  lock = NULL;

	We dereference lock in list_for_each_entry().  Maybe you want 
	list_for_each_entry_safe() or something?

  1791                                          else
  1792                                                  break;
  1793                                  }
  1794                                  if (lock)
  1795                                          break;

regards,
dan carpenter
