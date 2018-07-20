import { Component } from 'react'
import { Provider } from 'mobx-react'

import { setWeb3Instance, getManagers } from '../services/blockChainService'
import Shows from '../components/managers'
import Nav from '../components/navigation'

class Page extends Component {
    componentDidMount() {
        setWeb3Instance()
        .then(() => getManagers)
        .then(managers)
    }


    render() {
        return (
            <Provider store={this.props.store}>
                <div>
                    <Nav selected={this.props.type} />
                    <Shows {...this.props.store} />
                </div>
            </Provider>
        )
    }
}

export default Page