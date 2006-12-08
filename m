From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Dec  8 17:20:54 2006
Subject: [Ocfs2-devel] [patch 2/3]OCFS2: allow the ocfs2 heartbeat thread
	to prioritize I/O --revision 3
In-Reply-To: <4579B3B70200000400262DAC@lucius.provo.novell.com>
References: <4579B3B70200000400262DAC@lucius.provo.novell.com>
Message-ID: <20061209012050.GJ4497@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Zwei,

On Fri, Dec 08, 2006 at 12:48:26AM -0700, Zhen Wei wrote:
> - replace calling syscall interface with running ionice
> - fix the running ionice return code
> - use device name instead of uuid for mount.ocfs2

The kernel patch and the mount.ocfs2 patches look good. I only have a couple
of comments for this one below.


> @@ -289,6 +292,41 @@ static errcode_t start_heartbeat(struct 
>  	return err;
>  }
>  
> +static errcode_t adjust_priority(struct hb_ctl_options *hbo)
> +{
> +	int ret, child_status;
> +	pid_t hb_pid, child_pid;
> +	char level_arg[16], pid_arg[16];
> +
> +	if (access ("/usr/bin/ionice", X_OK) != 0)

You might want to make "/usr/bin/ionice" a #define at the top of this file,
since we use it at least twice.


> +		return OCFS2_ET_NO_IONICE;
> +
> +	get_uuid (hbo->dev_str, hbo->uuid_str);

You shouldn't have to call get_uuid() here -- see my comments below.


> @@ -385,6 +432,13 @@ static int process_options(struct hb_ctl
>  			ret = -EINVAL;
>  		break;
>  
> +	case HB_ACTION_IONICE:
> +		/* ionice needs uuid and priority */
> +		if (!hbo->dev_str || hbo->io_prio < 0 ||
> +		    hbo->io_prio > 7)
> +			ret = -EINVAL;
> +		break;

The ionice option should be just like the other options and allow the user
to specify an uuid _or_ a device. The main function will call get_uuid() if
the device was specified.

This will also help avoid the manual call to get_uuid() you have up in
adjust_priority().


> @@ -483,6 +538,14 @@ int main(int argc, char **argv)
>  		}
>  		break;
>  
> +	case HB_ACTION_IONICE:
> +		err = adjust_priority(&hbo);
> +		if (err) {
> +			com_err(progname, err, "while adjusting heartbeat thread I/O priority");
> +			ret = err;
> +		}

You're still printing errors unconditionally.

To break it down, the two errors we don't want to print for are:

* Not finding that the heartbeat region 'pid' attribute exists in configfs.
  (Should be an O2CB_ET_SERVICE_UNAVAILABLE return)

* Not being able to run /usr/bin/ionice because it doesn't exist.
  (Should be an OCFS2_ET_NO_IONICE return)

Neither of those two errors should be fatal, or should print to the user.
You'll have to filter them from the com_err.

Right now the rule is that all versions of ocfs2-tools must be compatible
with old versions of the file system module.

Thanks for the patches so far,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
