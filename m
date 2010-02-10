From: Dan Carpenter <error27@gmail.com>
Date: Wed, 10 Feb 2010 13:01:14 +0300
Subject: [Ocfs2-devel] ocfs2: bug in dlm_process_recovery_data()
In-Reply-To: <4B71A0FD.1020708@oracle.com>
References: <20100209080944.GA13283@bicker> <4B71A0FD.1020708@oracle.com>
Message-ID: <20100210100114.GC14210@bicker>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 09, 2010 at 09:53:01AM -0800, Sunil Mushran wrote:
> Dan Carpenter wrote:
>> I noticed a change was merged to dlm_process_recovery_data() so I  
>> thought you might want to fix this as well.
>>
>> fs/ocfs2/dlm/dlmrecovery.c
>>   1788                                  list_for_each_entry(lock, tmpq, list) {
>>   1789                                          if (lock->ml.cookie != ml->cookie)
>>   1790                                                  lock = NULL;
>>
>> 	We dereference lock in list_for_each_entry().  Maybe you want  
>> 	list_for_each_entry_safe() or something?
>>
>>   1791                                          else
>>   1792                                                  break;
>>   1793                                  }
>>   1794                                  if (lock)
>>   1795                                          break;
>>   
>
> Why? That's only required if we are deleting a list entry.

list_for_each() is defined in include/linux/list.h

/**
 * list_for_each_entry  -       iterate over list of given type
 * @pos:        the type * to use as a loop cursor.
 * @head:       the head for your list.
 * @member:     the name of the list_struct within the struct.
 */
#define list_for_each_entry(pos, head, member)                          \
        for (pos = list_entry((head)->next, typeof(*pos), member);      \
             prefetch(pos->member.next), &pos->member != (head);        \
             pos = list_entry(pos->member.next, typeof(*pos), member))
                              ^^^^^^^^^^^^^^^^

In this case "pos" is "lock" so the code basically is doing this:
lock = NULL;
lock = list_entry(lock->member.next, typeof(*lock), member));
                  ^^^^^^^^^^^^^^^^^
regards,
dan carpenter
