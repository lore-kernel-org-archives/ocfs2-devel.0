From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Wed Apr 21 18:57:26 2004
Subject: [Ocfs2-devel] Commenting patch
In-Reply-To: <40870854.1090005@intel.com>
References: <40870854.1090005@intel.com>
Message-ID: <20040421235719.GB23405@ca2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

John,

Eeeeek!  Sorry I should have said something!  I pretty much finished
mkfs over the last few days.  I couldn't take it anymore so I just went
ahead and did it over the weekend ;-)

How far along are you?  We should sync up.

-kurt

On Wed, Apr 21, 2004 at 04:48:36PM -0700, John L. Villalovos wrote:
> So I am working on trying to get mkfs doing all the initialization.  So in 
> the process I am commenting the kernel module code so that I will know what 
> is happenning.
> 
> So here are some comments I have added.
> 
> John
> 
> Index: super.c
> ===================================================================
> --- super.c	(revision 860)
> +++ super.c	(working copy)
> @@ -961,6 +961,8 @@
>  	
>  	osb->publ_map |= (1 << osb->node_num);
>  	osb->vol_state = VOLUME_INIT;
> +	// Check if first time this partition has been mounted.  If so create
> +	// the root Oracle INode.
>  	status = ocfs_create_root_oin (osb, NULL);
>  	if (status >= 0)
>  		osb->vol_state = VOLUME_ENABLED;
> Index: oin.c
> ===================================================================
> --- oin.c	(revision 860)
> +++ oin.c	(working copy)
> @@ -446,6 +446,11 @@
> 
>  /* ocfs_create_root_oin()
>   *
> + * This function will create the root Oracle INode (OIN) on the file 
> system if
> + * this is the first time that this partition has ever been mounted.
> + *
> + * If this is NOT the first time this partition has been mounted (meaning 
> it
> + * has been mounted before) then this function does nothing.
>   */
>  int ocfs_create_root_oin (ocfs_super * osb, struct inode *root)
>  {
> @@ -459,7 +464,15 @@
> 
>  	LOG_ENTRY ();
> 
> +	// Is this the first time this partition has been mounted?
>  	if (osb->vol_layout.root_start_off == 0) {
> +		// This is our first time being mounted.  We need to take 
> care
> +		// of setting up the root Oracle inode.  In order to do this 
> we
> +		// are going to call ocfs_create_root_dir_node.  So we need 
> to
> +		// get the disk offset to the root directory (root_dirnode).
> +		// In order to get that we need to read in the volume header
> +		// from the first sector of the disk.
> +
>  		status = ocfs_wait_for_disk_lock_release (osb, 
>  		OCFS_VOLUME_LOCK_OFFSET,
>  						 10000, OCFS_DLM_NO_LOCK);
>  		if (status < 0) {
> @@ -471,12 +484,14 @@
>  				     OCFS_DLM_EXCLUSIVE_LOCK, 
>  				     FLAG_FILE_CREATE,
>  				     &lockres, &bh, NULL);
>  		if (status >= 0) {
> +			// Read the volume header from the first sector of 
> the
> +			// partition and put it into our buffer head
>  			status = ocfs_read_bh(osb, 0, &hdr_bh, 0, NULL);
>  			if (status < 0)
>  				LOG_ERROR_STATUS (status);
> 
>  			tmpstat = ocfs_release_lock (osb, 
>  			OCFS_VOLUME_LOCK_OFFSET, OCFS_DLM_EXCLUSIVE_LOCK, 0, 
>  			lockres, bh, NULL);
> -	
> +
>  			if (bh)
>  				brelse(bh);
> 
> @@ -492,7 +507,13 @@
>  				LOG_ERROR_STATUS (status);
>  			goto finally;
>  		}
> -		
> +
> +		// Get the volume header data from our buffer head.  We need 
> to
> +		// know the following in order to call
> +		// ocfs_create_root_dir_node():
> +		//      * root_off: disk offset to the ocfs root dirnode
> +		//        (root_directory)
> +		//      * internal_off: disk offset tot he data segment
>  		volDiskHdr = (ocfs_vol_disk_hdr *) 
>  		OCFS_BH_GET_DATA_READ(hdr_bh); /* read */
>  		root_off = volDiskHdr->root_off;
>  		int_off = volDiskHdr->internal_off;
> @@ -502,10 +523,13 @@
>  			ocfs_wait_for_disk_lock_release (osb,
>  							OCFS_VOLUME_LOCK_OFFSET,
>  							30000, 
>  							OCFS_DLM_NO_LOCK);
> +			// Setup the root_start_off with the correct value so
> +			// that it will not run this function the next time 
> the
> +			// filesystem is mounted.
>  			osb->vol_layout.root_start_off = root_off;
>  			osb->vol_layout.root_int_off = int_off;
>  		}
> -
> +		// Do all the work in creating our root directory
>  		status = ocfs_create_root_dir_node (osb);
>  		if (status < 0) {
>  			LOG_ERROR_STATUS (status);
> 

> Index: super.c
> ===================================================================
> --- super.c	(revision 860)
> +++ super.c	(working copy)
> @@ -961,6 +961,8 @@
>  	
>  	osb->publ_map |= (1 << osb->node_num);
>  	osb->vol_state = VOLUME_INIT;
> +	// Check if first time this partition has been mounted.  If so create
> +	// the root Oracle INode.
>  	status = ocfs_create_root_oin (osb, NULL);
>  	if (status >= 0)
>  		osb->vol_state = VOLUME_ENABLED;
> Index: oin.c
> ===================================================================
> --- oin.c	(revision 860)
> +++ oin.c	(working copy)
> @@ -446,6 +446,11 @@
>  
>  /* ocfs_create_root_oin()
>   *
> + * This function will create the root Oracle INode (OIN) on the file system if
> + * this is the first time that this partition has ever been mounted.
> + *
> + * If this is NOT the first time this partition has been mounted (meaning it
> + * has been mounted before) then this function does nothing.
>   */
>  int ocfs_create_root_oin (ocfs_super * osb, struct inode *root)
>  {
> @@ -459,7 +464,15 @@
>  
>  	LOG_ENTRY ();
>  
> +	// Is this the first time this partition has been mounted?
>  	if (osb->vol_layout.root_start_off == 0) {
> +		// This is our first time being mounted.  We need to take care
> +		// of setting up the root Oracle inode.  In order to do this we
> +		// are going to call ocfs_create_root_dir_node.  So we need to
> +		// get the disk offset to the root directory (root_dirnode).
> +		// In order to get that we need to read in the volume header
> +		// from the first sector of the disk.
> +
>  		status = ocfs_wait_for_disk_lock_release (osb, OCFS_VOLUME_LOCK_OFFSET,
>  						 10000, OCFS_DLM_NO_LOCK);
>  		if (status < 0) {
> @@ -471,12 +484,14 @@
>  				     OCFS_DLM_EXCLUSIVE_LOCK, FLAG_FILE_CREATE,
>  				     &lockres, &bh, NULL);
>  		if (status >= 0) {
> +			// Read the volume header from the first sector of the
> +			// partition and put it into our buffer head
>  			status = ocfs_read_bh(osb, 0, &hdr_bh, 0, NULL);
>  			if (status < 0)
>  				LOG_ERROR_STATUS (status);
>  
>  			tmpstat = ocfs_release_lock (osb, OCFS_VOLUME_LOCK_OFFSET, OCFS_DLM_EXCLUSIVE_LOCK, 0, lockres, bh, NULL);
> -	
> +
>  			if (bh)
>  				brelse(bh);
>  
> @@ -492,7 +507,13 @@
>  				LOG_ERROR_STATUS (status);
>  			goto finally;
>  		}
> -		
> +
> +		// Get the volume header data from our buffer head.  We need to
> +		// know the following in order to call
> +		// ocfs_create_root_dir_node():
> +		//      * root_off: disk offset to the ocfs root dirnode
> +		//        (root_directory)
> +		//      * internal_off: disk offset tot he data segment
>  		volDiskHdr = (ocfs_vol_disk_hdr *) OCFS_BH_GET_DATA_READ(hdr_bh); /* read */
>  		root_off = volDiskHdr->root_off;
>  		int_off = volDiskHdr->internal_off;
> @@ -502,10 +523,13 @@
>  			ocfs_wait_for_disk_lock_release (osb,
>  							OCFS_VOLUME_LOCK_OFFSET,
>  							30000, OCFS_DLM_NO_LOCK);
> +			// Setup the root_start_off with the correct value so
> +			// that it will not run this function the next time the
> +			// filesystem is mounted.
>  			osb->vol_layout.root_start_off = root_off;
>  			osb->vol_layout.root_int_off = int_off;
>  		}
> -
> +		// Do all the work in creating our root directory
>  		status = ocfs_create_root_dir_node (osb);
>  		if (status < 0) {
>  			LOG_ERROR_STATUS (status);

> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
