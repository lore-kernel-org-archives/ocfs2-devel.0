From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 10 Jul 2009 11:13:09 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] a fix of logging return value.
In-Reply-To: <4A56E4ED.60101@oracle.com>
References: <200907100528.n6A5Sv4J030693@acsinet15.oracle.com>	<3A2AA175-B34E-4A01-8B9E-45361846B18C@oracle.com>	<4A56DE0F.3050009@oracle.com>
	<4A56E259.2030903@oracle.com> <4A56E4ED.60101@oracle.com>
Message-ID: <4A5784B5.40404@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> Hi wengang,
>
> Wengang Wang wrote:
>> Sunil,
>>
>> in the src, I see both mlog(ML_ERROR...)(finally printk(KERN_ERR...)) 
>> and ocfs2_error()(finally printk(KERN_CRIT...).
>> could you tell me in what case one should be used?
> mlog(ML_ERROR...) only print errors. But ocfs2_error does other 
> things, sometimes make the volume readonly. Please check 
> ocfs2_handle_error for details.
>

Yes. ocfs2_error() is only called when an ondisk structure read reveals
a corrupted block. Depending on the mount option, it either panics or
remounts ro.

printk(KERN_ERR) is only called if we need to print messages before
mlog_sys_init() is called. So you'll see those printks during module
loads.

There are few instances of printk(KERN_CRIT). We call them because mlog
does not handle such messages. We could add it. But there are only
3 instances of this message. So why bother.

The mlogs that you can use are:

mlog_errno() Error if the only information is ret/status.

mlog(ML_ERROR, ...) Error with vararg.

mlog(ML_NOTICE, ...) Notice with vararg. Use very very selectively as NOTICE
is enabled by default.

mlog(0, ...) Like notice but is printed only when the user enables the 
mask bit.
Use liberally.
 
mlog_entry() Entry with varargs. Use carefully. We don't want mlog to 
dereference
null pointers. ;)

mlog_entry_void() Entry with no args. Preferably use mlog(0) somewhere 
in the
middle of the function with usable information.

mlog_exit() All mlog_entry*() should have an exit.
mlog_exit_ptr()
mlog_exit_void()

We use mlog() to narrow down the scope of an error. Say a read is returning
EIO or EINVAL. By enabling tracing selectively, we can get more information.

However, too much tracing is counterproductive because not only is it hard
to wade thru the logs, the printk ring buffer loses a lot of messages. So,
when you add, think whether it will be useful. This is subjective of course.

An easy example would be function ocfs2_unlock_and_free_pages(). It does
what it says. Now we could add an entry and an exit trace. But the exit is
clearly useless because it does not return any information. So a better
solution could be to have a mlog(0, ...).

mlog(0, "num_pages = %d\n", num_pages);

Do not forget the trailing newline.

Thanks for taking on this task.
Sunil
