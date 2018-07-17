import Link from '../../../Library/Caches/typescript/2.9/node_modules/@types/next/link'
import NProgress from 'nprogress'
import Router from '../../../Library/Caches/typescript/2.9/node_modules/@types/next/router'

Router.onRouteChangeStart = url => NProgress.start()
Router.onRouteChangeComplete = () => NProgress.done()
Router.onRouteChangeError = () => NProgress.done()
  
export default ( { selected }) => {
    let {selectionFreshClass, selectionNewClass, selectionPopularClass, selectionBookmarksClass} = 'gray'
    
    switch(selected) {
        case 'bookmarks':
        selectionBookmarksClass = 'black b'
                break;
    }
    return (        
    <nav className={`pa3 pa4-ns`}>
        <Link href="/trans/home"><span className={`pointer link dim ${selectionBookmarksClass} f6 f5-ns dib mr3`} title="Bookmarks">Home</span></Link>    
    </nav>
    )
}