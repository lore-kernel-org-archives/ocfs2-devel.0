From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 29 Jan 2009 15:56:45 -0800
Subject: [Ocfs2-devel] Is ocfs2_create_new_lock() broken?
Message-ID: <20090129235645.GE12502@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Quick question:
	In ocfs2_create_new_inode_locks(), we claim:

1436         /*
1437          * We don't want to use DLM_LKF_LOCAL on a meta data lock as they
1438          * don't use a generation in their lock names.
1439          */
1440         ret = ocfs2_create_new_lock(osb, &OCFS2_I(inode)->ip_inode_lockres, 1, 0);

Ass you can see, we pass '0' for the 'local' argument to
ocfs2_create_new_lock().
	ocfs2_create_new_lock() certainly sets lkm_flags based on the
'local' argument.  But then it calls lockres_or_flags() with the
explicit flag, not with lkm_flags.  Is this wrong?

1387 static int ocfs2_create_new_lock(struct ocfs2_super *osb,
1388                                  struct ocfs2_lock_res *lockres,
1389                                  int ex,
1390                                  int local)
1391 {
1392         int level =  ex ? DLM_LOCK_EX : DLM_LOCK_PR;
1393         unsigned long flags;
1394         u32 lkm_flags = local ? DLM_LKF_LOCAL : 0;
1395 
1396         spin_lock_irqsave(&lockres->l_lock, flags);
1397         BUG_ON(lockres->l_flags & OCFS2_LOCK_ATTACHED);
1398         lockres_or_flags(lockres, OCFS2_LOCK_LOCAL);
1399         spin_unlock_irqrestore(&lockres->l_lock, flags);
1400 
1401         return ocfs2_lock_create(osb, lockres, level, lkm_flags);
1402 }

Joel

-- 

"Egotist: a person more interested in himself than in me."
         - Ambrose Bierce 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
