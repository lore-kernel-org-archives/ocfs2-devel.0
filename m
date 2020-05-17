From: David Laight <David.Laight@ACULAB.COM>
Date: Sun, 17 May 2020 08:48:02 +0000
Subject: [Ocfs2-devel] [PATCH 27/33] sctp: export sctp_setsockopt_bindx
In-Reply-To: <20200516153652.GM16070@bombadil.infradead.org>
References: <20200514062820.GC8564@lst.de>
	<20200513062649.2100053-1-hch@lst.de>
	<20200513062649.2100053-28-hch@lst.de>
	<20200513180058.GB2491@localhost.localdomain>
	<129070.1589556002@warthog.procyon.org.uk>
	<05d946ae948946158dbfcbc07939b799@AcuMS.aculab.com>
	<20200516153652.GM16070@bombadil.infradead.org>
Message-ID: <49f712b3b6704c3096d3834a5985a4d6@AcuMS.aculab.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Matthew Wilcox' <willy@infradead.org>
Cc: 'David Howells' <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, Jakub Kicinski <kuba@kernel.org>, linux-block@vger.kernel

From: Matthew Wilcox
> Sent: 16 May 2020 16:37
...
> > Basically:
> >
> > This patch sequence (to be written) does the following:
> >
> > Patch 1: Change __sys_setsockopt() to allocate a kernel buffer,
> >          copy the data into it then call set_fs(KERNEL_DS).
> >          An on-stack buffer (say 64 bytes) will be used for
> >          small transfers.
> >
> > Patch 2: The same for __sys_getsockopt().
> >
> > Patch 3: Compat setsockopt.
> >
> > Patch 4: Compat getsockopt.
> >
> > Patch 5: Remove the user copies from the global socket options code.
> >
> > Patches 6 to n-1; Remove the user copies from the per-protocol code.
> >
> > Patch n: Remove the set_fs(KERNEL_DS) from the entry points.
> >
> > This should be bisectable.
> 
> I appreciate your dedication to not publishing the source code to
> your kernel module, but Christoph's patch series is actually better.
> It's typesafe rather than passing void pointers around.

There are plenty on interfaces that pass a 'pointer and length'.
Having the compiler do a type check doesn't give any security
benefit - just stops silly errors.

Oh yes, I've attached the only driver source file that calls
into the Linux kernel.
You are perfectly free to look at all the thing we have to do
to support different and broken kernel releases.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
-------------- next part --------------
#ident "@(#) (c) Aculab plc $Header: /home/cvs/repository/ss7/stack/src/driver/linux/ss7osglue.c,v 1.157 2019-08-29 16:09:14 davidla Exp $ $Name:  $"
#ifndef MODULE
#define MODULE
#endif

#include <linux/version.h>

#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 28)
#error minimum kernel version is 2.6.28
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 34)
#include <generated/autoconf.h>
#else
#include <linux/autoconf.h>
#endif

#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/fs.h>
#include <linux/kmod.h>
#include <linux/string.h>
#include <linux/sched.h>
#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 11, 0)
#include <linux/sched/signal.h>
#endif
#include <linux/wait.h>
#include <linux/socket.h>
#include <linux/signal.h>
#include <linux/poll.h>
#include <linux/net.h>
#include <linux/nsproxy.h>
#include <linux/in.h>
#include <linux/reboot.h>
#include <asm/atomic.h>
#include <asm/uaccess.h>

#include <linux/kthread.h>

/* This is only in the kernel build tree */
#include <net/sock.h>

#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 10, 0)
#include <uapi/linux/sctp.h>
#else
#include <net/sctp/user.h>    /* netinet/sctp.h ought to be this file */
#endif

#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 13, 0)
#define wait_queue_head __wait_queue_head
#define wait_queue_entry __wait_queue
#endif

#define SK_PROTOCOL(sock) (sock)->sk->sk_protocol

extern void ss7_trace_mem(int, void *, int, const char *, ...);
extern void ss7_trace_printf(int, const char *, ...);

/* Aculab DACP interfaces - these are in aculab's kern_if.h */
void *dacp_symbol_get(const char *);
int dacp_symbol_release(const char *);

MODULE_AUTHOR("Aculab");
MODULE_LICENSE("Proprietary");

#include "ss7osglue.h"

/* Mutex for driver interface code */
static struct mutex ss7_glue_mutex;

static int ss7dev_major;
static const void *ss7_dtls_handle;
static int ss7_use_count;
static int ss7_stop_pid;

static struct task_struct *asserted_tasks[16];
static unsigned int asserted_task_count;

typedef char ss7_verify_const[ SS7_SOCK_STREAM == SOCK_STREAM && SS7_SOCK_SEQPACKET == SOCK_SEQPACKET ? 1 : -1];

static void ss7_net_ns_unload(void);

#define TCP_NODELAY 1

static int ss7_glue_open(struct inode *, struct file *);
static int ss7_glue_release(struct inode *, struct file *);
static long ss7_glue_unlocked_ioctl(struct file *, unsigned int, unsigned long);
static unsigned int ss7_glue_poll(struct file *const, poll_table *);

static struct file_operations ss7dev_fop =
{
    open:           ss7_glue_open,
    release:        ss7_glue_release,
    unlocked_ioctl: ss7_glue_unlocked_ioctl,
    compat_ioctl:   ss7_glue_unlocked_ioctl,
    poll:           ss7_glue_poll,
    owner:          THIS_MODULE
};

static int ss7_reboot_notify(struct notifier_block *nb, unsigned long action,
        void *data)
{
    /* System being rebooted.
     * I added this hoping to use it to get the ss7maint daemon to exit,
     * but it isn't called until all user processes have died.
     * Leave it here - might be useful one day. */
    return 0;
}

static struct notifier_block ss7_reboot_notifier_block = {
    .notifier_call = ss7_reboot_notify,
};

static int
ss7_init_fail(int rval)
{
    if (ss7dev_major > 0)
        unregister_chrdev(ss7dev_major, "ss7server");
    return rval;
}

static int
ss7_init_mod(void)
{
    const void *(*dtls_register)(const char *, int (*)(struct dtls_get_if *));
    int rval;

    ss7_mutex_init(&ss7_glue_mutex);

    printk(KERN_INFO "%s\n", ss7version);

    ss7dev_major = register_chrdev(0, "ss7server", &ss7dev_fop);

    if (ss7dev_major < 0) {
        printk(KERN_INFO "ss7server: register_chrdev() failed: %d\n",
                ss7dev_major);
        return ss7_init_fail(ss7dev_major);
    }

    rval = ss7_driver_init();
    if (rval != 0) {
        printk(KERN_INFO "ss7server: ss7_driver_init() failed: %d\n", rval);
        return ss7_init_fail(-EIO);
    }

    dtls_register = dacp_symbol_get("acuc_dtls_register");
    if (dtls_register == NULL)
        printk(KERN_INFO "ss7server: cannot locate \"acuc_dtls_register\"\n");
    else
        ss7_dtls_handle = dtls_register(DYNAMIC_TLS_PREFIX "ss7",
                ss7_tls_get_if);

    register_reboot_notifier(&ss7_reboot_notifier_block);
    return 0;
}

static void
ss7_cleanup_mod(void)
{
    int (*dtls_unregister)(const void *);

    unregister_reboot_notifier(&ss7_reboot_notifier_block);

    if (ss7_dtls_handle != NULL) {
        dtls_unregister = dacp_symbol_get("acuc_dtls_unregister");
        dacp_symbol_release("acuc_dtls_register");
        if (dtls_unregister != NULL) {
            dtls_unregister(ss7_dtls_handle);
            dacp_symbol_release("acuc_dtls_unregister");
        }
    }

    ss7_init_fail(0);

    printk(KERN_INFO "Aculab ss7server: driver unloaded\n");
}

module_init(ss7_init_mod)
module_exit(ss7_cleanup_mod)

static int
ss7_glue_open(struct inode *const inode, struct file *const filp)
{
    int rval, pid;

    if (filp->private_data)
        /* Duplicate open */
        return 0;

    ss7_mutex_enter(&ss7_glue_mutex);
    if (ss7_use_count < 0) {
        /* ss7_driver_shutdown() has been called, to late to do anything */
        ss7_mutex_exit(&ss7_glue_mutex);
        return -EIO;
    }
    ss7_use_count++;
    ss7_mutex_exit(&ss7_glue_mutex);

    rval = ss7_devif_open(&filp->private_data);
    if (rval != 0) {
        ss7_mutex_enter(&ss7_glue_mutex);
        ss7_use_count--;
        ss7_mutex_exit(&ss7_glue_mutex);
        pid = ss7_pid();
        if (pid != ss7_stop_pid)
            printk(KERN_INFO "ss7_devif_open() pid %d failed ss7 error %d\n",
                    pid, rval);
        return -EIO;
    }

    return 0;
}

static int
ss7_glue_release(struct inode *const inode, struct file *const filp)
{
    if (filp->private_data)
        ss7_devif_close(filp->private_data);

    ss7_mutex_enter(&ss7_glue_mutex);
    ss7_use_count--;

    if (ss7_use_count == 0 && ss7_stop_pid != 0) {
        /* Last user process has gone, complete shutdown functions */
        ss7_net_ns_unload();
        /* Stop any more opens */
        ss7_use_count = -1;
        ss7_driver_shutdown();
    }

    ss7_mutex_exit(&ss7_glue_mutex);

    return 0;
}

static long
ss7_glue_unlocked_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
    if (!filp->private_data)
        return -ENODEV;

    switch (cmd) {

    case SS7_STOP:          /* ss7maint shutting us down */
        /* Start shutdown now, will complete on last close */
        ss7_driver_stop();
        ss7_stop_pid = ss7_pid();
        return 0;

    /* Request from ss7maint or user application */
    case SS7_USER_IOCTL_CODE:
        return ss7dev_ioctl(filp->private_data, cmd, arg);

    default:
        return -ENOTTY;
    }
}

static unsigned int
ss7_glue_poll(struct file *filp, poll_table *pt)
{
    poll_wait(filp, *ss7_devif_get_pollqueue_head(filp->private_data), pt);
    return ss7_devif_get_poll_status(filp->private_data);
}

void *
ss7_os_malloc(int s, int ss7_flags)
{
    return kmalloc(s, GFP_KERNEL);
}

void
ss7_os_free(void *p)
{
    kfree(p);
}

void
ss7_poll_queue_head_deinit(wait_queue_head_t **pqhp)
{
    ss7_os_free(*pqhp);
}

int
ss7_poll_queue_head_init(wait_queue_head_t **pqhp)
{
    wait_queue_head_t *pqh = ss7_os_malloc(sizeof *pqh, 0);
    if (pqh == NULL)
        return -1;
    init_waitqueue_head(pqh);
    *pqhp = pqh;
    return 0;
}

void
ss7_pollwakeup(wait_queue_head_t **pqh, unsigned int poll_event)
{
    wake_up(*pqh);
}

void
ss7_kill_task(struct task_struct *task, int signo)
{
    /* Send signal even though set to SIG_IGN */
    force_sig(signo, task);
}


#if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 32)
/* spinlock_t is a typedef for an unnamed structure so we can't
 * make 'struct spinlock' match the kernel spinlock type. */
#define SPINLOCK_CAST (spinlock_t *)
#else
#define SPINLOCK_CAST
#endif

size_t
ss7_spin_lock_size(void)
{
    return sizeof *SPINLOCK_CAST(struct spinlock *)0;
}

void
ss7_spin_lock_init(struct spinlock *s)
{
    spin_lock_init(SPINLOCK_CAST s);
}

void
ss7_spin_lock_enter(struct spinlock *s)
{
    spin_lock(SPINLOCK_CAST s);
}

void
ss7_spin_lock_exit(struct spinlock *s)
{
    spin_unlock(SPINLOCK_CAST s);
}

size_t
ss7_mutex_size(void)
{
    return sizeof(struct mutex);
}

void
ss7_mutex_init(struct mutex *s)
{
    mutex_init(s);
}

void
ss7_mutex_enter(struct mutex *s)
{
    mutex_lock(s);
}

int
ss7_mutex_enter_tmo(struct mutex *s, int max_wait)
{
    /* There is no mutex_enter_timeout() however this was all added
     * to stop status commands sleeping forever when a process has
     * 'oopsed' with a mutex held.
     * Do a sneak check on the state of any owning task then
     * wait interruptibly.
     * ^C should error out the status call. */

    /* If uncontended just acquire */
    if (mutex_trylock(s))
        return 1;

#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 10, 0)
    {
        struct task_struct *owner;
        int state;

        spin_lock(&s->wait_lock);
        owner = __mutex_owner(s);
        state = owner ? owner->state : 0;
        spin_unlock(&s->wait_lock);
        if (state & TASK_DEAD)
            /* mutex will never be released, treat as timeout */
            return 0;
    }
#endif

    /* If C7_ASSERT() has been called, just let everyone in */
    if (asserted_task_count)
        return 0;

    return mutex_lock_interruptible(s) ? -1 /* EINTR */ : 1 /* acquired */;
}

void
ss7_mutex_exit(struct mutex *s)
{
    mutex_unlock(s);
}

size_t
ss7_cv_size(void)
{
    return sizeof(wait_queue_head_t);
}

void
ss7_cv_init(wait_queue_head_t *const v)
{
    init_waitqueue_head(v);
}

static int
ss7_schedule_tmo(int tmo_ms)
{
    int tmo_jiffies;

    /* Really sleep - unless woken since unlocking spinlock */
    if (tmo_ms >= 0) {
        if (tmo_ms <= 1)
            tmo_jiffies = tmo_ms;
        else
            /* Convert to jiffies and round up */
            tmo_jiffies = 1 + (tmo_ms + 1 - 1) * 16 / (16000/HZ);
        /* Return value of schedule_timeout() is unexpired timeout */
        /* We want 0 for 'timedout' (to match cv_wait_sig()) */
        return schedule_timeout(tmo_jiffies) != 0;
    }

    schedule();
    if (!signal_pending(current))
        /* Woken by the event */
        return 1;

    /* Report 0 for a signal, except -1 for SIGKILL (reboot) */
    return sigismember(&current->pending.signal, SIGKILL) ? -1 : 0;
}

int
ss7_cv_wait_guts(wait_queue_head_t *cvp, struct mutex *mtxp,
        int interruptible, int tmo_ms)
{
    int r;
    struct wait_queue_entry w;
    int sleep_state;

    init_waitqueue_entry(&w, current);

    /* Tell scheduler we are going to sleep... */
    if (signal_pending(current) && !interruptible)
        /* We don't want waking immediately (again) */
        sleep_state = TASK_UNINTERRUPTIBLE;
    else
        sleep_state = TASK_INTERRUPTIBLE;
    set_current_state(sleep_state);

    /* Connect to condition variable ... */
    add_wait_queue(cvp, &w);
    mutex_unlock(mtxp); /* Release mutex */

    r = ss7_schedule_tmo(tmo_ms);

    /* Disconnect from condition variable ... */
    remove_wait_queue(cvp, &w);

    /* Re-acquire mutex */
    mutex_lock(mtxp);

    /* return 1 if woken, 0 if timed_out/signal, -1 if SIGKILL */
    return r;
}

int
ss7_cv_wait_spin_lock(wait_queue_head_t *cvp, struct spinlock *lock,
        int interruptible, int tmo_ms)
{
    int r;
    struct wait_queue_entry w;
    int sleep_state;

    init_waitqueue_entry(&w, current);

    /* Tell scheduler we are going to sleep... */
    if (signal_pending(current) && !interruptible)
        /* We don't want waking immediately (again) */
        sleep_state = TASK_UNINTERRUPTIBLE;
    else
        sleep_state = TASK_INTERRUPTIBLE;
    set_current_state(sleep_state);

    /* Connect to condition variable ... */
    add_wait_queue(cvp, &w);
    spin_unlock(SPINLOCK_CAST lock);

    r = ss7_schedule_tmo(tmo_ms);

    /* Disconnect from condition variable ... */
    remove_wait_queue(cvp, &w);

    /* Re-acquire mutex */
    spin_lock(SPINLOCK_CAST lock);

    return r;
}

/*---------------------------------------------------------------------**
** ss7_cv_broadcast                                                    **
** Awaken all threads that are sleeping on a condition variable.       **
** Caller must use the associated mutex sensibly, i.e. ...             **
**      acquire the mutex                                              **
**      Set some flag that a sleeping thread will check for            **
**      ss7_cv_broadcast()                                             **
**      release the mutex                                              **
**---------------------------------------------------------------------*/

void
ss7_cv_broadcast(wait_queue_head_t *const cvp)
{
    wake_up(cvp);
}


unsigned long
ss7_copy_to_user(void *to, const void *from, unsigned long c)
{
    return copy_to_user(to, from, c);
}

unsigned long
ss7_copy_from_user(void *to, const void *from, unsigned long c)
{
    return copy_from_user(to, from, c);
}

unsigned int
ss7_pid(void)
{
    return current->pid;
}

struct task_struct *
ss7_current_task(void)
{
    return current;
}

unsigned int
ss7_task_pid(struct task_struct *task)
{
    return task->pid;
}

int
ss7_glue_thread_fn(void *ss7_thread)
{
    ss7_thread_run(ss7_thread);
    module_put_and_exit(0);
    return 0;
}

struct task_struct *
ss7_os_thread_create(struct ss7_thread *thrp, const char *desc)
{
    struct task_struct *task;
    const char *sp;
    int len;

    if (!try_module_get(THIS_MODULE))
        return NULL;

    /* The thread description gets truncated to 15 chars, can't be helped!
     * Use 'ss7maint osstatus -t' to get the full description. */

    /* Remove any leading space and truncate after second word */
    if (desc[0] == ' ')
        desc++;
    len = 100;
    sp = ss7strchr(desc, ' ');
    if (sp != NULL) {
        sp = ss7strchr(sp + 1, ' ');
        if (sp != NULL)
            len = sp - desc;
    }

    task = kthread_run(ss7_glue_thread_fn, thrp, "ss7:%.*s", len, desc);
    if (IS_ERR(task)) {
        module_put(THIS_MODULE);
        return NULL;
    }
    return task;
}

void
ss7_ms_delay(const unsigned int ms)
{
    set_current_state(TASK_UNINTERRUPTIBLE);
    schedule_timeout((unsigned long long)HZ * ms / 1000);
}

int
ss7_os_get_ticks(void)
{
    return jiffies;
}

int
ss7_os_ticks_to_us(int interval)
{
    return interval * 1000000 / HZ;
}

int
ss7_os_ticks_to_ms(int interval)
{
    return interval * 1000 / HZ;
}

int
ss7_os_ticks_to_secs(int interval)
{
    return interval / HZ;
}

unsigned int
ss7_get_ms_time(void)
{
    static unsigned long epoch;
    struct timespec now;

    getrawmonotonic(&now);

    if (epoch == 0)
       epoch = now.tv_sec;

    return (now.tv_sec - epoch) * 1000 + now.tv_nsec / 1000000;
}

struct acu_ss7maint_time {
   unsigned int st_sec;
   unsigned int st_usec;
};

#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 0, 0)
static inline void do_gettimeofday(struct timeval *tv)
{
        struct timespec64 ts;

        ktime_get_real_ts64(&ts);
        tv->tv_sec = ts.tv_sec;
        tv->tv_usec = ts.tv_nsec/1000u;
}
#endif

void
ss7_get_timestamp(struct acu_ss7maint_time *ptime)
{
    struct timeval tv;

    /* do_gettimeofday() returns 'wall clock time'.
     * It can go backwards.  */
    do_gettimeofday(&tv);
    ptime->st_sec = tv.tv_sec;
    ptime->st_usec = tv.tv_usec;
}

unsigned int
ss7_get_elapsed(const struct acu_ss7maint_time *epoch)
{
    struct timeval tv;
    do_gettimeofday(&tv);

    return tv.tv_sec - epoch->st_sec;
}

void
ss7_os_log_error(const char *text)
{
    printk(KERN_EMERG "ss7server: %s", text);
    if (memcmp(text, "Assertion fail", 14) == 0) {
        dump_stack();
        /* Although we return, the caller sleeps forever */
        /* Remember the 'stuck' tasks */
        asserted_tasks[asserted_task_count++ & 15] = current;
    }
}

/*---------------------------------------------------------------------**
** Miscellanous string and memory functions                            **
**---------------------------------------------------------------------*/

void
ss7memzero(void *buf, size_t len)
{
    memset(buf, 0, len);
}

void
ss7memcpy(void *dest, const void *src, size_t len)
{
    memcpy(dest, src, len);
}

void
ss7_memmove(void *dest, const void *src, size_t len)
{
    memmove(dest, src, len);
}

int
ss7memcmp(const void *s1, const void *s2, size_t len)
{
    return memcmp(s1, s2, len);
}

unsigned int
ss7strlen(const char *str)
{
    return strlen(str);
}

void
ss7strcpy(char *dest, const char *src)
{
    strcpy(dest, src);
}

int
ss7strcmp(const char *dest, const char *src)
{
    return strcmp(dest, src);
}

char *
ss7strncpy(char *const s1, const char *s2, size_t n)
{
    return strncpy(s1, s2, n);
}

char *
ss7strchr(const char *s, const int c)
{
    return strchr(s, c);
}

/*---------------------------------------------------------------------**
** TCP/IP functions                                                    **
**---------------------------------------------------------------------*/

int
ss7_sctp_supported(void)
{
    return 1;
}

unsigned int
ss7_get_default_af_opts(unsigned int protocol, unsigned int port)
{
    /* The SS7 driver needs to know the which address families (IPv4 or IPv6)
     * to use for listening sockets.
     *
     * Whether an IPV6 socket can accept IPV4 connections depends on
     * the IPV6_V6ONLY socket option. The default for which depends
     * on net.ipv6.bindv6only (which usually defaults to 0 - allowing IPV4).
     * There also might be kernels where clearing IPV6_V6ONLY is disallowed.
     *
     * Normally only a single socket is created for each port since an IPv6
     * socket can receive IPv4 connections. However a separate IPv4 socket
     * can be requested.
     *
     * This function should return one of:
     *    SS7_AF_OPT_IPv6
     *        IPV6 socket with the default IPV6_V6ONLY value.
     *    SS7_AF_OPT_IPv6_V6ONLY_CLR
     *        IPV6 socket with IPV6_V6ONLY explicitly cleared.
     *    SS7_AF_OPT_IPv6_V6ONLY_SET
     *        IPV6 socket with IPV6_V6ONLY explicitly set.
     * Possibly logically ored with:
     *    SS7_AF_OPT_IPv4
     *        A separate IPv4 socket.
     *
     * For flexibility the decision can be based on the protocol (either
     * IPPROTO_SCTP or IPPROTO_TCP) or the port number.
     *
     * Default to creating a single socket and disabling IPV6_V6ONLY.
     */
#ifndef SS7_DEFAULT_AF_OPTS
#define SS7_DEFAULT_AF_OPTS SS7_AF_OPT_IPv6
#endif
     return SS7_DEFAULT_AF_OPTS;
}

/* kernel_get/set_sockopt() prototypes have (char *) for the buffer.
 * #define a (void *) cast.
 */
#define kernel_setsockopt(sock, level, name, val, len) \
        kernel_setsockopt(sock, level, name, (void *)val, len)
#define kernel_getsockopt(sock, level, name, val, len) \
        kernel_getsockopt(sock, level, name, (void *)val, len)

/* Note that we can't (easily) hold reference counts on the namespace
 * because put_net() is GPL_ONLY.
 * Instead we keep our own table and create a socket to hold the
 * reference for us.
 * Table entries 0 and 1 always refer to init_net and the namespace
 * of the (last started) ss7 daemon. Neither is reference counted
 * (although we hold a single reference on the latter).
 * Higher entries are saved from invocations of 'ss7maint start'
 * and 'firmware download'. */

static struct ss7_ns_info {
    struct net    *ni_net_ns;
    struct socket *ni_sock;
    unsigned int  ni_refcount;
} ss7_ns_table[256];

static struct socket *
ss7_glue_create_ns_socket(struct net *net)
{
    struct socket *sock;

    if (__sock_create(net, AF_INET, SOCK_DGRAM, IPPROTO_UDP, &sock, 0))
        return NULL;
    return sock;
}

void
ss7_net_ns_get(unsigned int namespace)
{
    unsigned int idx = SS7_NET_NS_IDX(namespace);

    if (idx <= SS7_NET_NS_IDX(SS7_NET_NS_DAEMON))
        /* SS7_NET_NS_INIT and SS7_NET_NS_DAEMON aren't ref-counted */
        return;

    ss7_mutex_enter(&ss7_glue_mutex);
    ss7_ns_table[idx].ni_refcount++;
    ss7_mutex_exit(&ss7_glue_mutex);

    ss7_trace_printf(0, "ss7_net_ns_get(%x): refcount %d, sock %p, net %p\n",
            namespace, ss7_ns_table[idx].ni_refcount, ss7_ns_table[idx].ni_sock,
            ss7_ns_table[idx].ni_net_ns);
}

void
ss7_net_ns_put(unsigned int namespace)
{
    struct ss7_ns_info *ni;
    unsigned int idx = SS7_NET_NS_IDX(namespace);

    if (idx <= SS7_NET_NS_IDX(SS7_NET_NS_DAEMON))
        /* SS7_NET_NS_INIT and SS7_NET_NS_DAEMON aren't ref-counted */
        return;
    ni = ss7_ns_table + idx;

    ss7_trace_printf(0, "ss7_net_ns_put(%x): refcount %d, sock %p, net %p\n",
            namespace, ni->ni_refcount, ni->ni_sock, ni->ni_net_ns);

    ss7_mutex_enter(&ss7_glue_mutex);
    if (ni->ni_refcount && !--ni->ni_refcount) {
        /* Last reference gone */
        sock_release(ni->ni_sock);
        ni->ni_net_ns = NULL;
        ni->ni_sock = NULL;
    }
    ss7_mutex_exit(&ss7_glue_mutex);
}

static void
ss7_net_ns_unload(void)
{
    unsigned int idx;
    struct ss7_ns_info *ni;

    for (idx = 1; idx < ARRAY_SIZE(ss7_ns_table); idx++) {
        ni = ss7_ns_table + idx;
        if (!ni->ni_sock)
            continue;

        /* This should only report anything for the 'daemon' slot */
        printk(KERN_INFO "ss7_net_ns_unload(): idx %d, refcount %d, sock %p, net %p\n",
                idx, ni->ni_refcount, ni->ni_sock, ni->ni_net_ns);
        sock_release(ni->ni_sock);
        ni->ni_net_ns = NULL;
        ni->ni_sock = NULL;
        ni->ni_refcount = 0;
    }
}

unsigned int
ss7_net_ns_set(unsigned int new_namespace, unsigned int old_namespace)
{
    static unsigned int num_used_idx = 2;
    unsigned int idx, free_idx;
    struct ss7_ns_info *ni;
    struct net *net;

    /* The new_namespace should have the low 16 bits zero.
     * The low bits of old_namespace indicate what was actually being used. */

    if (new_namespace != SS7_NET_NS_START) {
        ss7_net_ns_put(old_namespace);
        return new_namespace == SS7_NET_NS_DAEMON ? SS7_NET_NS_DAEMON : SS7_NET_NS_INIT;
    }

    /* SS7_NET_NS_START - look for an entry for the namespace of the current 
     * process (which will be 'ss7maint start'). */
    net = current->nsproxy->net_ns;

    idx = SS7_NET_NS_IDX(old_namespace);
    ni = ss7_ns_table + idx;
    if (ni->ni_net_ns == net)
        /* Unchanged index, no need to change reference count */
        return SS7_NET_NS_START | idx;

    /* Different slot needed, drop old reference */
    ss7_net_ns_put(old_namespace);

    /* Check init and daemon entries, neither goes away */
    if (idx != SS7_NET_NS_IDX(SS7_NET_NS_INIT)
            && net == &init_net)
        return SS7_NET_NS_START | SS7_NET_NS_IDX(SS7_NET_NS_INIT);

    idx = SS7_NET_NS_IDX(SS7_NET_NS_DAEMON);
    ni = ss7_ns_table + idx;
    if (net == ni->ni_net_ns)
        return SS7_NET_NS_START | idx;

    ss7_mutex_enter(&ss7_glue_mutex);

    /* Scan table for an existing reference */
    free_idx = 0;
    for (idx = 2; idx < num_used_idx; idx++) {
        ni = ss7_ns_table + idx;
        if (ni->ni_net_ns == net) {
            /* found a match */
            ni->ni_refcount++;
            ss7_mutex_exit(&ss7_glue_mutex);
            ss7_trace_printf(0, "ss7_net_ns_set(%x, %x): found idx %d, refcount %d, sock %p, net %p\n",
                    new_namespace, old_namespace, idx, ni->ni_refcount, ni->ni_sock, ni->ni_net_ns);
            return SS7_NET_NS_START | idx;
        }
        if (!free_idx && !ni->ni_net_ns)
            free_idx = idx;
    }

    /* Not found allocate lowest free slot */
    if (!free_idx) {
        if (num_used_idx >= ARRAY_SIZE(ss7_ns_table))
            /* Table full, borked */
            goto no_ref;
        free_idx = num_used_idx++;
    }

    ni = &ss7_ns_table[free_idx];
    ni->ni_sock = ss7_glue_create_ns_socket(net);
    if (!ni->ni_sock)
        goto no_ref;
    ni->ni_net_ns = net;

    ss7_mutex_exit(&ss7_glue_mutex);
    ss7_trace_printf(0, "ss7_net_ns_set(%x, %x): new idx %d, sock %p, net %p\n",
            new_namespace, old_namespace, free_idx, ni->ni_sock, ni->ni_net_ns);

    return SS7_NET_NS_START | free_idx;

  no_ref:
    ss7_mutex_exit(&ss7_glue_mutex);
    ss7_trace_printf(0, "ss7_net_ns_set(%x, %x): no_ref\n",
            new_namespace, old_namespace);
    return SS7_NET_NS_START;
}

void
ss7_glue_daemon_open(void)
{
    struct ss7_ns_info *ni = &ss7_ns_table[SS7_NET_NS_IDX(SS7_NET_NS_DAEMON)];
    struct net *net = current->nsproxy->net_ns;

    /* Save (and reference count) the network namespace the ss7 daemon
     * is started in. */

    /* Initialise the entry for init_net here - has to be done somewhere. */
    ss7_ns_table[SS7_NET_NS_IDX(SS7_NET_NS_INIT)].ni_net_ns = &init_net;

    if (net == ni->ni_net_ns)
        /* Unchanged */
        return;

    if (ni->ni_sock)
        sock_release(ni->ni_sock);
    ni->ni_sock = NULL;

    if (net != &init_net && !((ni->ni_sock = ss7_glue_create_ns_socket(net))))
        /* Can't create socket, default to global namespace */
        net = &init_net;

    ni->ni_net_ns = net;
}

int
ss7_socket(int family, int type, int protocol, unsigned int namespace, struct socket **sockp)
{
    struct socket *sock;
    struct net *net;
    unsigned int one = 1U;
    int rval;

    net = ss7_ns_table[SS7_NET_NS_IDX(namespace)].ni_net_ns;
    if (!net)
        net = &init_net;

    /* If we have to autoload the sctp module, we might re-enter it
     * before it has finished initialising - might go 'boom'. */
    ss7_mutex_enter(&ss7_glue_mutex);

    /* sock_create_kern() creates a socket that doesn't hold a reference
     * to the namespace (they get used for sockets needed by the protocol
     * stack code itself).
     * We need a socket that holds a reference to the namespace, so create
     * a 'user' socket in a specific namespace.
     * This adds an extra security check which we should pass because all the
     * sockets are created by kernel threads.
     */
    rval = __sock_create(net, family, type, protocol, sockp, 0);
    ss7_mutex_exit(&ss7_glue_mutex);
    if (rval != 0)
        return rval;
    sock = *sockp;

    kernel_setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one);

    return 0;
}

void
ss7_setsockopt_nodelay(struct socket *sock, int enabled)
{
    kernel_setsockopt(sock, SK_PROTOCOL(sock),
            SK_PROTOCOL(sock) == IPPROTO_TCP ? TCP_NODELAY : SCTP_NODELAY,
            &enabled, sizeof enabled);
}

static void
ss7_sctp_set_opts(struct socket *sock)
{
    struct sctp_event_subscribe events;
    int len, rval;

    if (SK_PROTOCOL(sock) != IPPROTO_SCTP)
        return;

    len = sizeof events;
    rval = kernel_getsockopt(sock, IPPROTO_SCTP, SCTP_EVENTS, &events, &len);
    if (rval != 0)
        return;

    /* We need to know the stream and ppid */
    events.sctp_data_io_event = 1;
    /* Enable notifications to detect connection restart */
    events.sctp_association_event = 1;
    kernel_setsockopt(sock, IPPROTO_SCTP, SCTP_EVENTS, &events, sizeof events);
}

unsigned int
ss7_get_max_sctp_ostreams(struct socket *sock)
{
    struct sctp_status sstat;
    int len;

    if (SK_PROTOCOL(sock) != IPPROTO_SCTP)
        return 0;

    len = sizeof sstat;
    if (kernel_getsockopt(sock, IPPROTO_SCTP, SCTP_STATUS, &sstat, &len))
        return 0;

    return sstat.sstat_outstrms;
}

void
ss7_set_max_sctp_streams(struct socket *sock, unsigned int max_streams)
{
    struct sctp_initmsg sinit;

    if (SK_PROTOCOL(sock) != IPPROTO_SCTP)
        return;

    memset(&sinit, 0, sizeof sinit);

    sinit.sinit_num_ostreams = max_streams;
    sinit.sinit_max_instreams = max_streams;
    kernel_setsockopt(sock, IPPROTO_SCTP, SCTP_INITMSG, &sinit, sizeof sinit);
}

void
ss7_trans_setsockopt(struct socket *sock)
{
    unsigned int one = 1U;

    ss7_setsockopt_nodelay(sock, 1);
    ss7_sctp_set_opts(sock);
    if (SK_PROTOCOL(sock) == IPPROTO_TCP)
        kernel_setsockopt(sock, SOL_SOCKET, SO_KEEPALIVE, &one, sizeof one);
}

void
ss7_transbind_setsockopt(struct socket *sock)
{
    /* Set options for a listening socket */
    ss7_sctp_set_opts(sock);

    /* M3UA may need 16 data streams, it is just TFH to configure this */
    ss7_set_max_sctp_streams(sock, 1 + 16);
}

#define IP_ADDR_LEN(sa) ((sa)->sin6_family == AF_INET6 ? sizeof *(sa) : 16)
int
ss7_connect(struct socket *sock, struct sockaddr_in6 *sa)
{
    return kernel_connect(sock, (void *)sa, IP_ADDR_LEN(sa), O_RDWR);
}

int
ss7_bind(struct socket *sock, struct sockaddr_in6 *sa, unsigned int af_opts)
{
    /* If we are binding INADDR6_ANY to an IPv6 socket (typically for
     * a listening socket) then we probably want to ensure that IPV6_V6ONLY
     * is 0 so that the socket will also be given IPv4 connections. */
    if (sa->sin6_family == AF_INET6 && af_opts & SS7_AF_OPT_IPv6_V6ONLY
            && sa->sin6_addr.in6_u.u6_addr32[0] == 0
            && (sa->sin6_addr.in6_u.u6_addr32[1]
                | sa->sin6_addr.in6_u.u6_addr32[2]
                | sa->sin6_addr.in6_u.u6_addr32[3]) == 0) {
        int v6only = af_opts & 1;
        kernel_setsockopt(sock, IPPROTO_IPV6, IPV6_V6ONLY, &v6only, sizeof v6only);
    }

    return kernel_bind(sock, (void *)sa, IP_ADDR_LEN(sa));
}

int
ss7_bindx(struct socket *sock, struct sockaddr_in6 *sa)
{
    if (SK_PROTOCOL(sock) != IPPROTO_SCTP)
        return -EPROTONOSUPPORT;

    return kernel_setsockopt(sock, IPPROTO_SCTP, SCTP_SOCKOPT_BINDX_ADD,
            sa, IP_ADDR_LEN(sa));
}

int
ss7_listen(struct socket *sock, int len)
{
    return kernel_listen(sock, len);
}

int
ss7_accept(struct socket *sock, struct socket **new_sockp, int flags)
{
    return kernel_accept(sock, new_sockp, flags);
}

#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 17, 0)
static inline int
ss7_kernel_getsockname(struct socket *sock, struct sockaddr *address)
{
    int err, len;

    err = kernel_getsockname(sock, (struct sockaddr *)address, &len);
    return err ? err : len;
}
#define kernel_getsockname ss7_kernel_getsockname

static inline int
ss7_kernel_getpeername(struct socket *sock, struct sockaddr *address)
{
    int err, len;

    err = kernel_getpeername(sock, (struct sockaddr *)address, &len);
    return err ? err : len;
}
#define kernel_getpeername ss7_kernel_getpeername
#endif

int
ss7_get_loc_port(struct socket *sock)
{
    char address[128 /*MAX_SOCK_ADDR*/];
    int len;

    len = kernel_getsockname(sock, (struct sockaddr *)address);
    if (len < 0)
        return 0;

    /* This works well enough for IPv4 and IPv6 */
    return ntohs(((struct sockaddr_in *)address)->sin_port);
}

int
ss7_get_rem_addr(struct socket *sock, struct sockaddr_in6 *saddr)
{
    int len;

    len = kernel_getpeername(sock, (struct sockaddr *)saddr);
    if (len < 0)
        return len;

    if (len > sizeof *saddr)
        printk(KERN_EMERG "ss7server: socket address (family %d) %d > %d",
                saddr->sin6_family, len, (int)sizeof *saddr);

    return 0;
}

int
ss7_shutdown(struct socket *sock, int how)
{
#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 18, 0)
    if (SK_PROTOCOL(sock) == IPPROTO_SCTP) {
        struct linger linger;

        /* If we call kernel_sock_shutdown() then the connection isn't released
         * until all outstanding data has been acked.
         * If the remote system sends an INIT (restarting the connection)
         * while the linux kernel is waiting for data to be acked then it
         * will never disconnect.
         * Enabling 'linger' with a delay of zero causes sock_release()
         * to abort the connection (sends an ABORT chunk).
         *
         * The ss7 code never needs to wait for sent data to be acked,
         * so aborting the connection doesn't really matter.
         * All calls to ss7_shutdown() are immediately followed by calls to
         * ss7_closesocket().
         *
         * Plausibly we should always abort connections if we are disconnecting
         * due to an application level timeout.
         *
         * Fixed by the kernel patch:
         *    "sctp: handle association restarts when the socket is closed"
         * Known to be included in the following kernels:
         *  - mainline 3.18
         *  - Ubuntu 3.13.11.11
         * Queued for 3.10-stable, 3.14-stable, 3.16-stable and 3.17-stable
         */

        linger.l_onoff = 1;
        linger.l_linger = 0;
        kernel_setsockopt(sock, SOL_SOCKET, SO_LINGER, &linger, sizeof linger);

        return 0;
    }
#endif
    return kernel_sock_shutdown(sock, how);
}

void
ss7_closesocket(struct socket *sock)
{
    sock_release(sock);
}

int
ss7_send(struct socket *sock, struct ss7_iovec *iov, int iovlen, int totlen,
        void *ctl, int ctl_len, unsigned int flags)
{
    struct msghdr msg;

    msg.msg_name       = 0;
    msg.msg_namelen    = 0;
    msg.msg_control    = ctl;
    msg.msg_controllen = ctl_len;
    msg.msg_flags      = flags | MSG_NOSIGNAL;

    return kernel_sendmsg(sock, &msg, iov, iovlen, totlen);
}

int
ss7_recv(struct socket *sock, unsigned char *data, int length, int flags)
{
    struct kvec iov;
    struct msghdr msg;

    if (!sock->sk)
        return 0;

    iov.iov_len        = length;
    iov.iov_base       = data;

    msg.msg_name       = 0;
    msg.msg_namelen    = 0;
    msg.msg_control    = NULL;
    msg.msg_controllen = 0;
    msg.msg_flags      = 0;

    return kernel_recvmsg(sock, &msg, &iov, 1, length, 0);
}

int
ss7_recv_sctp(struct socket *sock, void *buf_1, int len_1, void *buf_2,
    int len_2, struct ss7_msgb *ss7_msg)
{
    struct msghdr msg;
    struct kvec iov[2];
    unsigned char *data = buf_1;
    int msg_len, ctl_len;
    int rval;
    union {
        struct cmsghdr cmsg;
        unsigned int buf[16];
    } ctlbuf;

    if (!sock->sk)
        return 0;

    /* For SCTP each recvmsg should give us a single data record.
     * Since we only ever send SIGTRAN encoded messages bytes 4-7 are the
     * length - and should match that of the sctp data chunk.
     * buf_1/len_1 refer to the normal ss7 message buffer area, buf_2/len_2
     * are per-socket. Long messages get copied together by the caller.
     * The result is always a single valid SIGTRAN message */

    iov[0].iov_base    = buf_1;
    iov[0].iov_len     = len_1;
    iov[1].iov_base    = buf_2;
    iov[1].iov_len     = len_2;

    msg.msg_name       = 0;
    msg.msg_namelen    = 0;
    msg.msg_control    = &ctlbuf;
    msg.msg_controllen = sizeof ctlbuf;
    msg.msg_flags      = 0;

    rval = kernel_recvmsg(sock, &msg, iov, 2, len_1 + len_2, 0);

    if (rval <= 0)
        /* Don't return EBADMSG here */
        return rval != -EBADMSG ? rval : -EIO;

    if (msg.msg_flags & MSG_NOTIFICATION)
        /* msg data is a notification */
        return -EBADMSG;

    ctl_len = (char *)msg.msg_control - (char *)&ctlbuf;
    if (ctl_len >= ctlbuf.cmsg.cmsg_len
            && ctlbuf.cmsg.cmsg_level == IPPROTO_SCTP
            && ctlbuf.cmsg.cmsg_type == SCTP_SNDRCV) {
        struct sctp_sndrcvinfo *sinfo = CMSG_DATA(&ctlbuf.cmsg);
        ss7_trans_set_msg_info(ss7_msg, sinfo->sinfo_stream, sinfo->sinfo_ppid);
    }

    msg_len = data[4] << 24 | data[5] << 16 | data[6] << 8 | data[7];
    if (msg_len >= 65556)
        /* Disbelieve this is valid data */
        return -EIO;

    if (rval != msg_len || !(msg.msg_flags & MSG_EOR))
        return -EIO;
    return rval;
}

int
ss7_trans_init_sctp_sinfo(void *buf, int maxlen, __u16 **stream, __u32 **ppid)
{
    struct cmsghdr *cmsg;
    struct sctp_sndrcvinfo *sinfo;

    if (maxlen < CMSG_LEN(sizeof *sinfo))
        return -1;

    cmsg = buf;
    cmsg->cmsg_level = IPPROTO_SCTP;
    cmsg->cmsg_type = SCTP_SNDRCV;
    cmsg->cmsg_len = CMSG_LEN(sizeof *sinfo);
    sinfo = CMSG_DATA(cmsg);
    memset(sinfo, 0, sizeof *sinfo);
    *stream = &sinfo->sinfo_stream;
    *ppid = &sinfo->sinfo_ppid;

    return CMSG_LEN(sizeof *sinfo);
}
