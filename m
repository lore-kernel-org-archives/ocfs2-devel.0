From: Zhen Wei <zwei@novell.com>
Date: Thu Dec  7 18:12:40 2006
Subject: =?UTF-8?Q?=E7=AD=94=E5=A4=8D=EF=BC=9A=20Re:=20[Ocfs2-devel]=20[p?=
	=?UTF-8?Q?atch=202/2]OCFS2:=20allow=20the=20ocfs2=20heartbeat=20thread?=
	=?UTF-8?Q?=20to=20prioritize=20I/O?=
Message-ID: <457964B40200000400262D3B@lucius.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

hi, Mark:

zhen wei
zwei@novell.com
+86 10 65339225

>>> Mark Fasheh <mark.fasheh@oracle.com> 06?12?08? ?? 8:20 >>>
>> +errcode_t o2cb_get_hb_thread_pid (const char *cluster_name, const char *region_name,
>> +			   pid_t *pid)
>> +{
>> +	char attr_path[PATH_MAX];
>> +	char _fake_cluster_name[NAME_MAX];
>> +	char attr_value[16];
>> +	errcode_t ret;
>> +
>> +	if (!cluster_name) {
>> +		ret = _fake_default_cluster(_fake_cluster_name);
>> +		if (ret)
>> +			return ret;
>> +		cluster_name = _fake_cluster_name;
>> +	}

>Hmm, I don't see any other test for cluster_name == NULL in similar code
>paths... Is there any particular reason why you added one?

o2cb_remove_heartbeat_region() and o2cb_create_heartbeat_region() also have similar code,
_fake_default_cluster() shuold return default cluster name. 

>> --- /tmp/ocfs2-tools-1.2.2/ocfs2_hb_ctl/ocfs2_hb_ctl.c	2006-10-20 01:10:46.000000000 +0800
>> +++ ocfs2_hb_ctl/ocfs2_hb_ctl.c	2006-12-07 10:04:10.000000000 +0800
>> @@ -29,6 +29,7 @@
>> +_syscall3(int, ioprio_set, int, which, int, who, int, ioprio);
>> +_syscall2(int, ioprio_get, int, which, int, who);

>After looking at all this, and realizing that the proper syscall definitions
>don't exist anywhere on a modern distro, I'm begining to think that perhaps
>we want to just fork and exec /usr/bin/ionice.
>It seems more future maintainable than defining the syscall interface
>ourselves.

ok, I will replace syscall interface with exec ionice.

>> +	case HB_ACTION_IONICE:
>> +		err = adjust_priority(&hbo);
>> +		if (err) {
>> +			com_err(progname, err, "while adjusting heartbeat thread I/O priority");
>> +			ret = -EINVAL;

>So, one thing I don't want to see is spurious errors if the set_ioprio or
>ionice stuff doesn't exist - this should work just fine without confusing
>users if they're still on an old kernel. You probably then want to filter
>out any errors pertaining to the existence (or not) of that api.

oh, this is my careless, I have defined a UNSUPPORTED error_code, but not return it at this place.

thanks for pointing out my mistakes for correction!
