From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 09 Feb 2010 09:53:01 -0800
Subject: [Ocfs2-devel] ocfs2: bug in dlm_process_recovery_data()
In-Reply-To: <20100209080944.GA13283@bicker>
References: <20100209080944.GA13283@bicker>
Message-ID: <4B71A0FD.1020708@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Dan Carpenter wrote:
> I noticed a change was merged to dlm_process_recovery_data() so I 
> thought you might want to fix this as well.
>
> fs/ocfs2/dlm/dlmrecovery.c
>   1788                                  list_for_each_entry(lock, tmpq, list) {
>   1789                                          if (lock->ml.cookie != ml->cookie)
>   1790                                                  lock = NULL;
>
> 	We dereference lock in list_for_each_entry().  Maybe you want 
> 	list_for_each_entry_safe() or something?
>
>   1791                                          else
>   1792                                                  break;
>   1793                                  }
>   1794                                  if (lock)
>   1795                                          break;
>   

Why? That's only required if we are deleting a list entry.
