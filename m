From: Eric W. Biederman <ebiederm@xmission.com>
Date: Fri, 08 Jan 2010 16:55:07 -0800
Subject: [Ocfs2-devel] +
	sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
	added to -mm tree
In-Reply-To: <20100109000853.GC24532@mail.oracle.com> (Joel Becker's message
	of "Fri\, 8 Jan 2010 16\:08\:53 -0800")
References: <201001082354.o08NsLGV021886@imap1.linux-foundation.org>
	<20100109000853.GC24532@mail.oracle.com>
Message-ID: <m1r5q09jx0.fsf@fess.ebiederm.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker <Joel.Becker@oracle.com> writes:

> On Fri, Jan 08, 2010 at 03:54:20PM -0800, akpm at linux-foundation.org wrote:
>> 
>> The patch titled
>>      sysctl: use RCU protected sysctl for ocfs group add helper
>> has been added to the -mm tree.  Its filename is
>>      sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
>
> NAK until I can figure out how to make it always succeed.  We can't have
> umount "succeed" like this.
>
> Maybe the solution is GFP_ATOMIC.  Maybe the solution is to lock on the
> setting end.  But this isn't it.

My observation is that most of the issues rcu_string are memory allocation
issues.

Suppose we define rcu_string as:

struct rcu_string_head {
        char *str;
	size_t size;
        char data[];
}

#define DEFINE_RCU_STRING(NAME, SIZE, VAL)	\
struct {					\
	char *str;       			\
	size_t size;				\
        char data[SIZE + SIZE];		        \
} NAME = {					\
	.str = NAME.data,			\
        .size = SIZE,				\
        .data = VAL,				\
}

Accesses would be:
        char *str; 
	rcu_read_lock();
        str = rcu_deref(NAME.str);
        ....
	rcu_read_unlock();

Updates would be:
        char *next;
	mutex_lock(&rcu_string_mutex);
        next = rcu_string->data;
        if (next == rcu_string->str)
        	next = rcu_string->data + rcu_string->size;
        memcpy(next, somestring_from_somewhere, rcu_string->size);
        next[rcu_string->size - 1] = '\0';
        rcu_string->str = next;
        synchronize_rcu();
        mutex_unlock(&rcu_string_mutex);

Thoughts?

Eric
