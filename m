From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 13 Mar 2017 16:12:42 +0800
Subject: [Ocfs2-devel] [PATCH 02/17] Single Run: kernel building is
	little broken now
In-Reply-To: <1481606975-13186-3-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
	<1481606975-13186-3-git-send-email-zren@suse.com>
Message-ID: <c950b2f6-575f-545c-a7d3-bd99ba056271@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/13/2016 01:29 PM, Eric Ren wrote:
> Only check kernel source if we specify "buildkernel" test case.
> The original kernel source web-link cannot be reached,
> so give a new link instead but the md5sum check is missing
> now.
> 
> Signed-off-by: Eric Ren <zren@suse.com>
> ---
>  programs/python_common/single_run-WIP.sh | 56 ++++++++++++++++----------------
>  1 file changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/programs/python_common/single_run-WIP.sh b/programs/python_common/single_run-WIP.sh
> index fe0056c..61008d8 100755
> --- a/programs/python_common/single_run-WIP.sh
> +++ b/programs/python_common/single_run-WIP.sh
> @@ -20,9 +20,9 @@ WGET=`which wget`
>  WHOAMI=`which whoami`
>  SED=`which sed`
>  
> -DWNLD_PATH="http://oss.oracle.com/~smushran/ocfs2-test"
> -KERNEL_TARBALL="linux-kernel.tar.gz"
> -KERNEL_TARBALL_CHECK="${KERNEL_TARBALL}.md5sum"
> +DWNLD_PATH="https://cdn.kernel.org/pub/linux/kernel/v3.x/"
> +KERNEL_TARBALL="linux-3.2.80.tar.xz"
> +#KERNEL_TARBALL_CHECK="${KERNEL_TARBALL}.md5sum"

Can we compute the md5sum manually and put it here?

Thanks,
Junxiao.

>  USERID=`${WHOAMI}`
>  
>  DEBUGFS_BIN="${SUDO} `which debugfs.ocfs2`"
> @@ -85,7 +85,7 @@ get_bits()
>  # get_kernel_source $LOGDIR $DWNLD_PATH $KERNEL_TARBALL $KERNEL_TARBALL_CHECK
>  get_kernel_source()
>  {
> -	if [ "$#" -lt "4" ]; then
> +	if [ "$#" -lt "3" ]; then
>  		${ECHO} "Error in get_kernel_source()"
>  		exit 1
>  	fi
> @@ -93,18 +93,18 @@ get_kernel_source()
>  	logdir=$1
>  	dwnld_path=$2
>  	kernel_tarball=$3
> -	kernel_tarball_check=$4
> +	#kernel_tarball_check=$4
>  
>  	cd ${logdir}
>  
>  	outlog=get_kernel_source.log
>  
> -	${WGET} -o ${outlog} ${dwnld_path}/${kernel_tarball_check}
> -	if [ $? -ne 0 ]; then
> -		${ECHO} "ERROR downloading ${dwnld_path}/${kernel_tarball_check}"
> -		cd -
> -		exit 1
> -	fi
> +#	${WGET} -o ${outlog} ${dwnld_path}/${kernel_tarball_check}
> +#	if [ $? -ne 0 ]; then
> +#		${ECHO} "ERROR downloading ${dwnld_path}/${kernel_tarball_check}"
> +#		cd -
> +#		exit 1
> +#	fi
>  
>  	${WGET} -a ${outlog} ${dwnld_path}/${kernel_tarball}
>  	if [ $? -ne 0 ]; then
> @@ -113,13 +113,13 @@ get_kernel_source()
>  		exit 1
>  	fi
>  
> -	${MD5SUM} -c ${kernel_tarball_check} >>${outlog} 2>&1
> -	if [ $? -ne 0 ]; then
> -		${ECHO} "ERROR ${kernel_tarball_check} check failed"
> -		cd -
> -		exit 1
> -	fi
> -	cd -
> +#	${MD5SUM} -c ${kernel_tarball_check} >>${outlog} 2>&1
> +#	if [ $? -ne 0 ]; then
> +#		${ECHO} "ERROR ${kernel_tarball_check} check failed"
> +#		cd -
> +#		exit 1
> +#	fi
> +#	cd -
>  }
>  
>  # do_format() ${BLOCKSIZE} ${CLUSTERSIZE} ${FEATURES} ${DEVICE}
> @@ -1012,16 +1012,6 @@ LOGFILE=${LOGDIR}/single_run.log
>  
>  do_mkdir ${LOGDIR}
>  
> -if [ -z ${KERNELSRC} ]; then
> -	get_kernel_source $LOGDIR $DWNLD_PATH $KERNEL_TARBALL $KERNEL_TARBALL_CHECK
> -	KERNELSRC=${LOGDIR}/${KERNEL_TARBALL}
> -fi
> -
> -if [ ! -f ${KERNELSRC} ]; then
> -	${ECHO} "No kernel source"
> -	usage
> -fi
> -
>  STARTRUN=$(date +%s)
>  log_message "*** Start Single Node test ***"
>  
> @@ -1058,6 +1048,16 @@ for tc in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
>  	fi
>  
>  	if [ "$tc"X = "buildkernel"X -o "$tc"X = "all"X ];then
> +		if [ -z ${KERNELSRC} ]; then
> +			get_kernel_source $LOGDIR $DWNLD_PATH $KERNEL_TARBALL #$KERNEL_TARBALL_CHECK
> +			KERNELSRC=${LOGDIR}/${KERNEL_TARBALL}
> +		fi
> +
> +		if [ ! -f ${KERNELSRC} ]; then
> +			${ECHO} "No kernel source"
> +			usage
> +		fi
> +
>  		run_buildkernel ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${KERNELSRC}
>  	fi
>  
> 
